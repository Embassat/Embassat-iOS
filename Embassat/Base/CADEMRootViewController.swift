//
//  CADEMRootViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMRootViewController: CADRootViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.emBackgroundColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: nil)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
