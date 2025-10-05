//
//  ViewManager.swift
//  BankApp
//
//  Created by Валентин on 3.10.25.
//

import UIKit

final class ViewManager {
    static let shared = ViewManager()
    
    private init() {} //Запррет на создание новых экземпляров - точка входа в данный экземпляр статичское свойство shared. Больше экзмпляров создать нельзя и наследоваться от данного класса тоже. Называется СИНГЛТОН
    
    let colors: [[String]] = [
        ["#16A085FF", "#003F32FF"],
        ["#9A00D1FF", "#45005DFF"],
        ["#FA6000FF", "#FAC6A6FF"],
        ["#DE0007FF", "#8A0004FF"],
        ["#2980B9FF", "#2771A1FF"],
        ["#E74C3CFF", "#93261BFF"]
    ]
    
    let images: [UIImage] = [
        .icon1,
        .icon2,
        .icon3,
        .icon4,
        .icon5,
        .icon6
    ]
    
    func getGradient(frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 306, height: 175)), colors: [String]) -> CAGradientLayer {
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{color in
            UIColor(hex: color)?.cgColor ?? UIColor.white.cgColor // чтобы не было опционала
        }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 1]
        
        return gradient
    }
    
    
    
    func getCard(colors: [String], balance: Float, cardNumber: String, cardImage: UIImage) -> UIView {
        let card = {
            let card = UIView()
            let gradient = self.getGradient(colors: colors)
            //card.layer.addSublayer(gradient) //устанавливаем градиент на слой, тк у нас мы не знаем на коам слое будет находится фон, то мыз аменеим на.insertSublayer
            card.layer.insertSublayer(gradient, at: 0) //тут мы точно знаем, что вставляем слой на 0 уровень
            card.clipsToBounds = true //все что выходит за пределы карточки  - обрезать - аналаг overflow:hidden
            card.layer.cornerRadius = 30
            card.translatesAutoresizingMaskIntoConstraints = false //Отключаем старое позиционирование чтобы управлять автолайаутом вручную
            card.widthAnchor.constraint(equalToConstant: 306).isActive = true // фикчируем размеры карточки через системы autolayout
            card.heightAnchor.constraint(equalToConstant: 175).isActive = true //
            
            card.tag = 7 //даем ему тэг, чтобы его можно было найти и поменять слой
            return card
        }()
        
        //Окончание заготовки самой карты
        // начинаем делать украшательства
        let imageView = {
            let imageView = UIImageView()
            imageView.image = cardImage
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.layer.opacity = 0.5
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 150),
                imageView.heightAnchor.constraint(equalToConstant: 150),
                
            ])
            
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let balanceLabel = {
            let balanceLabel = UILabel()
            balanceLabel.text = "$\(balance)"
            balanceLabel.textColor = .white
            balanceLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            return balanceLabel
            
        }()
        
        let numberLabel = {
            let numberLabel = UILabel()
            numberLabel.text = "****\(cardNumber)"
            numberLabel.textColor = .white
            numberLabel.layer.opacity = 0.3 //Затратная вещь - главное не усерствовать
            return numberLabel
        }()
        
        let hStack = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing //горизонтальное выравнивание
            stack.alignment = .center
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(balanceLabel) //метод добавляет в стек вью и управляет его позиционированием
            stack.addArrangedSubview(numberLabel)
            return stack
        }()
        
        card.addSubview(imageView) //Добавляе дочерний элемт типа view на другой view
        card.addSubview(hStack)
        
        //Располагаем дочерний субвью относительно карты
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: 30),
            
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 30),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -30),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -30)
        ])
        
        
        return card
    }
    
    func getSlideTitle(titleText: String) -> UILabel{
        let title = UILabel()
        title.text = titleText
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }
    
    func getCollection (id: String, dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) -> UICollectionView{
        let collection : UICollectionView = {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 62, height: 62)
            layout.minimumLineSpacing = 15
            layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30) //отступы для одной ячейки
            
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.restorationIdentifier = id
            collection.delegate = delegate
            collection.dataSource = dataSource
            
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.heightAnchor.constraint(equalToConstant: 70).isActive = true
            collection.backgroundColor = .clear
            collection.showsHorizontalScrollIndicator = false
            return collection
        }()
        
        return collection
    }
}
