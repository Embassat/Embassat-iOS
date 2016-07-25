//
//  AppDelegate.swift
//  Embassa't
//
//  Created by Joan Romano on 23/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit
import ShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NotificationService().registerForLocalNotifications()
        SHKConfiguration.sharedInstanceWithConfigurator(ShareKitConfigurator())
        
        setupAppearance()
        
        let interactor = MenuInteractor()
        let coordinator = MenuCoordinator()
        let viewModel = MenuViewModel(interactor: interactor, coordinator: coordinator)
        let viewController = MenuViewController(viewModel: viewModel)
        viewController.bind(to: interactor)
        coordinator.viewController = viewController
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = RootNavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        SHKFacebook.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        SHKFacebook.handleWillTerminate()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme.hasPrefix("fb\(SHKConfiguration.sharedInstance().configurationValue("facebookAppId", withObject: nil))") {
            return SHKFacebook.handleOpenURL(url, sourceApplication: sourceApplication)
        }
        
        return true
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.emBarTintColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont.titleFont(ofSize: 30)!
        ]
    }
    
}
