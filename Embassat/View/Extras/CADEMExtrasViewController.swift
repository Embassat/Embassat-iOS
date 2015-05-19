//
//  CADEMExtrasViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMExtrasViewController: CADEMRootViewControllerSwift {
    
    @IBOutlet var titleLabels: [UILabel]?
    @IBOutlet var bodyLabels: [UILabel]?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Extres"
        
        view.backgroundColor = UIColor.whiteColor()
        
        if let labels = titleLabels {
            for label in labels {
                label.font = UIFont.em_titleFontOfSize(16.0)
            }
        }
        
        if let labels = bodyLabels {
            for label in labels {
                label.font = UIFont.em_detailFontOfSize(16.0)
            }
        }
    }

}
