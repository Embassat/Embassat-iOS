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
        
        let tabInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        // Info 
        
        let mapInteractor = MapInteractor()
        let mapViewController = MapViewController(binding: mapInteractor) { (interactor, _) in
            return MapViewModel(interactor: mapInteractor)
        }
        
        let infoSection = TabContainerSection(title: "Info", viewController: InfoViewController())
        let transportSection = TabContainerSection(title: "Transport", viewController: TransportViewController())
        let mapSection = TabContainerSection(title: "Mapa", viewController: mapViewController)
        let ticketsSection = TabContainerSection(title: "Entrades", viewController: TicketsViewController())
        
        let containerViewModel = TabContainerViewModel(title: "Info",
                                                       sections: [infoSection, transportSection, mapSection, ticketsSection])
        let containerViewController = TabContainerViewController(viewModel: containerViewModel)
        
        let infoNavigationController = RootNavigationController(rootViewController: containerViewController)
        infoNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabInfo"), selectedImage: UIImage(named: "tabInfoSelected")?.withRenderingMode(.alwaysOriginal))
        infoNavigationController.tabBarItem.imageInsets = tabInsets
        
        // Artists
        
        let artistsInteractor = ArtistsInteractor()
        let artistsCoordinator = ArtistsCoordinator()
        let artistsViewController = ArtistsViewController(binding: artistsInteractor) { (interactor, _) in
            return ArtistsViewModel(interactor: interactor, coordinator: artistsCoordinator)
        }
        let artistsNavigationController = RootNavigationController(rootViewController: artistsViewController)
        artistsNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabArtists"), selectedImage: UIImage(named: "tabArtistsSelected")?.withRenderingMode(.alwaysOriginal))
        artistsNavigationController.tabBarItem.imageInsets = tabInsets
        artistsCoordinator.viewController = artistsViewController
        
        // Schedule
        
        let scheduleSections: [TabContainerSection] = [ScheduleInteractorDay.first, ScheduleInteractorDay.second]
            .map { (day) in
            let scheduleInteractor = ScheduleInteractor(day: day)
            let scheduleCoordinator = ScheduleCoordinator()
            let scheduleViewController = ScheduleViewController(binding: scheduleInteractor) { (interactor, _) in
                return ScheduleViewModel(interactor: scheduleInteractor, coordinator: scheduleCoordinator)
            }
            
            return TabContainerSection(title: day.title, viewController: scheduleViewController)
        }
        
        let scheduleContainerViewModel = TabContainerViewModel(title: "Horaris", sections: scheduleSections)
        let scheduleContainerViewController = TabContainerViewController(viewModel: scheduleContainerViewModel)
        let scheduleNavigationController = RootNavigationController(rootViewController: scheduleContainerViewController)
        scheduleNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabSchedule"), selectedImage: UIImage(named: "tabScheduleSelected")?.withRenderingMode(.alwaysOriginal))
        scheduleNavigationController.tabBarItem.imageInsets = tabInsets
        
        // Tab bar
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [infoNavigationController, artistsNavigationController, scheduleNavigationController]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundImage = UIImage.withColor(color: UIColor.primary.withAlphaComponent(0.95),
                                                                    size: CGSize(width: 1,
                                                                                 height: tabBarController.tabBar.bounds.height))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
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
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage.withColor(color: UIColor.primary.withAlphaComponent(0.95),
                                                                          size: UIScreen.main.bounds.size),
                                                        for: .default)
        UINavigationBar.appearance().tintColor = .secondary
        UINavigationBar.appearance().barTintColor = .primary
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.secondary,
            NSFontAttributeName : UIFont.titleFont(ofSize: 30)!
        ]
    }
    
}
