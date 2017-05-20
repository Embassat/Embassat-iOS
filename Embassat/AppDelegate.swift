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
        
        let mapInteractor = MapInteractor()
        let mapViewModel = MapViewModel(interactor: mapInteractor)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        mapViewController.bind(to: mapInteractor)
        
        let infoSection = ContainerSection(title: "Info", viewController: InfoViewController())
        let transportSection = ContainerSection(title: "Transport", viewController: TransportViewController())
        let mapSection = ContainerSection(title: "Mapa", viewController: mapViewController)
        let ticketsSection = ContainerSection(title: "Entrades", viewController: TicketsViewController())
        
        let containerViewModel = InfoContainerViewModel(sections: [infoSection, transportSection, mapSection, ticketsSection])
        let containerViewController = InfoContainerViewController(viewModel: containerViewModel)
        
        let infoNavigationController = RootNavigationController(rootViewController: containerViewController)
        infoNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabInfo"), selectedImage: UIImage(named: "tabInfoSelected")?.withRenderingMode(.alwaysOriginal))
        infoNavigationController.tabBarItem.imageInsets = tabInsets
        
        let artistsInteractor = ArtistsInteractor()
        let artistsCoordinator = ArtistsCoordinator()
        let artistsViewModel = ArtistsViewModel(interactor: artistsInteractor, coordinator: artistsCoordinator)
        let artistsViewController = ArtistsViewController(viewModel: artistsViewModel)
        let artistsNavigationController = RootNavigationController(rootViewController: artistsViewController)
        artistsNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabArtists"), selectedImage: UIImage(named: "tabArtistsSelected")?.withRenderingMode(.alwaysOriginal))
        artistsNavigationController.tabBarItem.imageInsets = tabInsets
        artistsViewController.bind(to: artistsInteractor)
        artistsCoordinator.viewController = artistsViewController
        artistsInteractor.fetchArtists()
        
        let scheduleInteractor = ScheduleInteractor()
        let scheduleCoordinator = ScheduleCoordinator()
        let scheduleViewModel = ScheduleViewModel(interactor: scheduleInteractor, coordinator: scheduleCoordinator)
        let scheduleViewController = ScheduleViewController(viewModel: scheduleViewModel)
        let scheduleNavigationController = RootNavigationController(rootViewController: scheduleViewController)
        scheduleNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabSchedule"), selectedImage: UIImage(named: "tabScheduleSelected")?.withRenderingMode(.alwaysOriginal))
        scheduleNavigationController.tabBarItem.imageInsets = tabInsets
        scheduleViewController.bind(to: scheduleInteractor)
        scheduleCoordinator.viewController = scheduleViewController
        scheduleInteractor.fetchArtists()
        
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
