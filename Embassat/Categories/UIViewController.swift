//
//  UIViewController.swift
//  Embassat
//
//  Created by Joan Romano on 21/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /// Adds a child view controller to the receiver
    ///
    /// - Parameter newViewController: the new child `UIViewController`
    func em_addChildViewController(_ newViewController: UIViewController)   {
        addChildViewController(newViewController)
        view.addSubview(newViewController.view)
        newViewController.didMove(toParentViewController: self)
    }
    
    /// Removes the receiver from his parent view controller
    func em_removeFromParentViewController() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
}
