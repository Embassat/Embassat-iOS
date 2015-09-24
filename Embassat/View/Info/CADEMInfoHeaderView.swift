//
//  CADEMInfoHeaderView.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMInfoHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var coverImage: UIImageView?
    
    public var title: String = "" {
        didSet {
            titleLabel?.text = title
        }
    }
    public var cover: UIImage? = nil {
        didSet {
            coverImage?.image = cover
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font = UIFont.detailFont(ofSize: 20.0)
    }
}
