//
//  MenuCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: RootCollectionViewCell {
    
    @IBOutlet weak var optionNameLabel: UILabel?
    var optionName: String = "" {
        didSet {
            optionNameLabel?.text = optionName
        }
    }
    
    override func setupView() {
        super.setupView()
        
        optionNameLabel?.font = UIFont.detailFont(ofSize: 30.0)
        optionNameLabel?.adjustsFontSizeToFitWidth = true
    }
}
