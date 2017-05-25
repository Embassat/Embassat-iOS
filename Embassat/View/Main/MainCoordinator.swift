//
//  MainCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 21/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation
import ShareKit

final class MainCoordinator {
    
    typealias LaunchingResult = (result: Bool, window: UIWindow)
    private let tabInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> LaunchingResult {
        registerServices()
        setupAppearance()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = createRootViewController()
        window.makeKeyAndVisible()
        
        return (true, window)
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
    
    // MARK: - Private
    
    private func registerServices() {
        NotificationService().registerForLocalNotifications()
        SHKConfiguration.sharedInstance(with: ShareKitConfigurator())
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage.withColor(color: UIColor.primary.withAlphaComponent(0.95),
                                                                          size: UIScreen.main.bounds.size),
                                                        for: .default)
        UINavigationBar.appearance().tintColor = .secondary
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.secondary,
            NSFontAttributeName : UIFont.titleFont(ofSize: 30)!
        ]
    }
    
    private func createRootViewController() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [infoTab(), artistsTab(), scheduleTab()]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundImage = UIImage.tabBackgroundImage(with: CGSize(width: 1,
                                                                                          height: tabBarController.tabBar.bounds.height))
        
        return tabBarController
    }
    
    private func infoTab() -> UIViewController {
        let mapInteractor = MapInteractor()
        let mapViewController = MapViewController(binding: mapInteractor) { (interactor, _) in
            return MapViewModel(interactor: mapInteractor)
        }
        
        let infoSection = TabContainerSection(title: String.infoTitle, viewController: InfoViewController())
        let transportSection = TabContainerSection(title: String.transportTitle, viewController: TransportViewController())
        let mapSection = TabContainerSection(title: String.mapTitle, viewController: mapViewController)
        let ticketsSection = TabContainerSection(title:String.ticketsTitle, viewController: TicketsViewController())
        
        let containerViewModel = TabContainerViewModel(title: String.infoTitle,
                                                       sections: [infoSection, transportSection, mapSection, ticketsSection])
        let containerViewController = TabContainerViewController(viewModel: containerViewModel)
        
        let infoNavigationController = RootNavigationController(rootViewController: containerViewController)
        infoNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabInfo, selectedImage: UIImage.tabInfoSelected)
        infoNavigationController.tabBarItem.imageInsets = tabInsets
        
        return infoNavigationController
    }
    
    private func artistsTab() -> UIViewController {
        let artistsInteractor = ArtistsInteractor()
        let artistsCoordinator = ArtistsCoordinator()
        let artistsViewController = ArtistsViewController(binding: artistsInteractor) { (interactor, _) in
            return ArtistsViewModel(interactor: interactor, coordinator: artistsCoordinator)
        }
        let artistsNavigationController = RootNavigationController(rootViewController: artistsViewController)
        artistsNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabArtists, selectedImage: UIImage.tabArtistsSelected)
        artistsNavigationController.tabBarItem.imageInsets = tabInsets
        artistsCoordinator.viewController = artistsViewController
        
        return artistsNavigationController
    }
    
    private func scheduleTab() -> UIViewController {
        let scheduleSections: [TabContainerSection] = [ScheduleInteractorDay.first, ScheduleInteractorDay.second]
            .map { (day) in
                let scheduleInteractor = ScheduleInteractor(day: day)
                let scheduleCoordinator = ScheduleCoordinator()
                let scheduleViewController = ScheduleViewController(binding: scheduleInteractor) { (interactor, _) in
                    return ScheduleViewModel(interactor: scheduleInteractor, coordinator: scheduleCoordinator)
                }
                scheduleCoordinator.viewController = scheduleViewController
                
                return TabContainerSection(title: day.title, viewController: scheduleViewController)
        }
        
        let scheduleContainerViewModel = TabContainerViewModel(title: String.scheduleTitle, sections: scheduleSections)
        let scheduleContainerViewController = TabContainerViewController(viewModel: scheduleContainerViewModel)
        let scheduleNavigationController = RootNavigationController(rootViewController: scheduleContainerViewController)
        scheduleNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabSchedule, selectedImage: UIImage.tabScheduleSelected)
        scheduleNavigationController.tabBarItem.imageInsets = tabInsets
        
        return scheduleNavigationController
    }
}
