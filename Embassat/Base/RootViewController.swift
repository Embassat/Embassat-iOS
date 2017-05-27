//
//  RootViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

protocol Trackeable {
    var screen: Analytics.Screen { get }
    var parameters: [String : Any]? { get }
}

extension Trackeable {
    var parameters: [String : Any]? { return nil }
}

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let trackeable = self as? Trackeable {
            Analytics.trackScreenView(trackeable.screen, parameters: trackeable.parameters)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
