//
//  ViewController.swift
//  BankApp
//
//  Created by Валентин on 3.10.25.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var builder = {return ViewBuilder(controller: self)}()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor(hex: "1E1E1E")
        builder.setPageTitle(title: "Design your virtual card")
        builder.getCard()
        builder.getColorSlider()
    }


}

