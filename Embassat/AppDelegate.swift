//
//  AppDelegate.swift
//  Embassa't
//
//  Created by Joan Romano on 23/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let coordinator = MainCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let launchingResult = coordinator.application(application, didFinishLaunchingWithOptions: launchOptions)
        window = launchingResult.window
        
        return launchingResult.result
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        coordinator.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coordinator.applicationWillTerminate(application)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return coordinator.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}
