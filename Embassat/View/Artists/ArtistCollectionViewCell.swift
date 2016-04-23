//
//  ArtistCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ArtistCollectionViewCell: RootCollectionViewCell {
    
    @IBOutlet weak var optionNameLabel: UILabel?
    @IBOutlet weak var bottomSeparator: UIView?
    
    var optionName: String = "" {
        didSet {
            optionNameLabel?.text = optionName
        }
    }
    var hidesBottomSeparator: Bool = false {
        didSet {
            bottomSeparator?.hidden = hidesBottomSeparator
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                selectElements()
            } else {
                deselectElements()
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                selectElements()
            } else {
                deselectElements()
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        optionNameLabel?.font = UIFont.detailFont(ofSize: 15.0)
        optionNameLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func selectElements() {
        contentView.backgroundColor = .blackColor()
        optionNameLabel?.textColor = .whiteColor()
    }
    
    private func deselectElements() {
        contentView.backgroundColor = .whiteColor()
        optionNameLabel?.textColor = .blackColor()
    }
}
