//
//  ColorCell.swift
//  BankApp
//
//  Created by Валентин on 5.10.25.
//

import UIKit

class ColorCell: UICollectionViewCell{

        
    func setCell(colors: [String]){
        let gradient = ViewManager.shared.getGradient(frame: CGRect(origin: .zero, size: CGSize(width: 62, height: 62)),colors: colors)
        self.layer.addSublayer(gradient)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }

}
