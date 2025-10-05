//
//  ViewBilder.swift
//  BankApp
//
//  Created by Валентин on 3.10.25.
//

import UIKit

final class ViewBuilder: NSObject {
    
    private let manager = ViewManager.shared //Ссылка на другой обьект ViewManager
    private var card = UIView() //Переменная банковской карты
    private let balance: Float = 9.998
    private let cardNumber: String = "4444"
    private var colorCollection: UICollectionView!
    private var imageCollection: UICollectionView!
    
    var cardColors: [String] = [
        "#16A085FF", "#003F32FF"
    ]{
        willSet {
            //функционал при смене цвета - это момент переназначения свойства - начало переопределения переменной
            if let colorView = view.viewWithTag(7){
                colorView.layer.sublayers?.remove(at: 0)
                let gradient = manager.getGradient(colors: newValue)
                colorView.layer.insertSublayer(gradient, at: 0)
            }
        }
    }
    var cardIcon: UIImage = .icon3{
        willSet {
            //функционал при смене цвета - это момент переназначения свойства
        }
    }
    
    
     
    var controller: UIViewController
    var view : UIView
    
    init(controller: UIViewController) {
        self.controller = controller
        self.view = controller.view
    }
    private lazy var pageTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.numberOfLines = 0
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false // отключаем старый вариант позиционирования чтобы страбатывал auto layout
        return title
    }()
    
    func setPageTitle(title: String){
        pageTitle.text = title
        view.addSubview(pageTitle)
        NSLayoutConstraint.activate([
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func getCard(){
        card = manager.getCard(colors: cardColors, balance: balance, cardNumber: cardNumber, cardImage: cardIcon)
        print(cardIcon)
        view.addSubview(card)
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 30),
            
            ])
    }
        
    func getColorSlider(){
        let colorTitle = manager.getSlideTitle(titleText: "Select color")
        colorCollection = manager.getCollection(id: RestoreIDs.colors.rawValue, dataSource: self, delegate: self)
        colorCollection.register(ColorCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(colorTitle)
        view.addSubview(colorCollection)
        
        NSLayoutConstraint.activate([
            colorTitle.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 30),
            colorTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            colorTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            colorCollection.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 20),
            colorCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    
}


extension ViewBuilder: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.restorationIdentifier {
        case RestoreIDs.colors.rawValue :
            return manager.colors.count
        case RestoreIDs.images.rawValue:
            return manager.images.count
        default :
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.restorationIdentifier {
           case RestoreIDs.colors.rawValue :
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColorCell {
                
                let color = manager.colors[indexPath.item]
                
                cell.setCell(colors: color)
                
                return cell
            }
            default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    
        
        //функция переопределяет цвет карточки через делегат
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.restorationIdentifier {
        case RestoreIDs.colors.rawValue :
            let colors = manager.colors[indexPath.item]
            self.cardColors = colors
        //case RestoreIDs.images.rawValue:
            
        default :
           return
        }
    }
    
}

enum RestoreIDs: String {
    case colors, images
}
