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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationService().registerForLocalNotifications()
        SHKConfiguration.sharedInstance(with: ShareKitConfigurator())
        
        setupAppearance()
        
        let interactor = MenuInteractor()
        let coordinator = MenuCoordinator()
        let viewModel = MenuViewModel(interactor: interactor, coordinator: coordinator)
        let viewController = MenuViewController(viewModel: viewModel)
        viewController.bind(to: interactor)
        coordinator.viewController = viewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootNavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SHKFacebook.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SHKFacebook.handleWillTerminate()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        guard let scheme = url.scheme else { return true }
        
        if scheme.hasPrefix("fb\(SHKConfiguration.sharedInstance().configurationValue("facebookAppId", with: nil))") {
            return SHKFacebook.handleOpen(url, sourceApplication: sourceApplication)
        }
        
        return true
    }
    
    fileprivate func setupAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor.emBarTintColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.titleFont(ofSize: 30)!
        ]
    }
    
}
