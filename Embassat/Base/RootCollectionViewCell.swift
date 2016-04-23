//
//  RootCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class RootCollectionViewCell: UICollectionViewCell {
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    func setupView() {}
}
