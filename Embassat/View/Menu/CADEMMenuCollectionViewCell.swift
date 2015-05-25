//
//  CADEMMenuCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMMenuCollectionViewCell: CADRootCollectionViewCell {
    
    @IBOutlet weak var optionNameLabel: UILabel?
    public var optionName: String = "" {
        didSet {
            optionNameLabel?.text = optionName
        }
    }
    
    override public var selected: Bool {
        didSet {
            if selected {
                optionNameLabel?.textColor = UIColor.em_barTintColor()
            } else {
                optionNameLabel?.textColor = UIColor.whiteColor()
            }
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            if highlighted {
                optionNameLabel?.textColor = UIColor.em_barTintColor()
            } else {
                optionNameLabel?.textColor = UIColor.whiteColor()
            }
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        optionNameLabel?.font = UIFont.em_titleFontOfSize(30.0)
        optionNameLabel?.adjustsFontSizeToFitWidth = true
    }
}
