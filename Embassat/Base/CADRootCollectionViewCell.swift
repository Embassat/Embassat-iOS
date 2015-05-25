//
//  CADRootCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADRootCollectionViewCell: UICollectionViewCell {
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        
        self.setupView()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    public func setupView() {}
}
