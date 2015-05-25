//
//  CADEMInfoCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMInfoCollectionViewCell: CADRootCollectionViewCell {
    
    @IBOutlet weak var bodyLabel: UILabel?
    public var body: String = "" {
        didSet {
            bodyLabel?.text = body
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        bodyLabel?.font = UIFont.em_detailFontOfSize(15.0)
    }

}
