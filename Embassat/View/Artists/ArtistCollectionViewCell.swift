//
//  ArtistCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class ArtistCollectionViewCell: RootCollectionViewCell {
    
    @IBOutlet weak var optionNameLabel: UILabel?
    @IBOutlet weak var bottomSeparator: UIView?
    
    var optionName: String = "" {
        didSet {
            optionNameLabel?.text = optionName
        }
    }
    var hidesBottomSeparator: Bool = false {
        didSet {
            bottomSeparator?.isHidden = hidesBottomSeparator
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectElements()
            } else {
                deselectElements()
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
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
    
    fileprivate func selectElements() {
        contentView.backgroundColor = UIColor.primary.withAlphaComponent(0.5)
        optionNameLabel?.textColor = .primary
    }
    
    fileprivate func deselectElements() {
        contentView.backgroundColor = .secondary
        optionNameLabel?.textColor = .primary
    }
}

