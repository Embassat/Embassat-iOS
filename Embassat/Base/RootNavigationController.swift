//
//  RootNavigationController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }
}
