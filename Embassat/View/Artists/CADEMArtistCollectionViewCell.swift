//
//  CADEMArtistCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistCollectionViewCell: CADRootCollectionViewCell {
    
    @IBOutlet weak var optionNameLabel: UILabel?
    @IBOutlet weak var bottomSeparator: UIView?
    
    public var optionName: String = "" {
        didSet {
            optionNameLabel?.text = optionName
        }
    }
    public var hidesBottomSeparator: Bool = false {
        didSet {
            bottomSeparator?.hidden = hidesBottomSeparator
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        optionNameLabel!.font = UIFont.em_detailFontOfSize(15.0)
        optionNameLabel?.adjustsFontSizeToFitWidth = true
    }
    
}

