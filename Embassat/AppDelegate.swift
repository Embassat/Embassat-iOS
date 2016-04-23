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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NotificationService().registerForLocalNotifications()
        SHKConfiguration.sharedInstanceWithConfigurator(ShareKitConfigurator())
        
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = RootNavigationController(rootViewController: MenuViewController(MenuViewModel(model: ["Info", "Artistes", "Horaris", "Petit EM'", "Transport", "Mapa", "Entrades"])))
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
            NSFontAttributeName : UIFont.detailFont(ofSize: 30)!
        ]
    }
    
}
