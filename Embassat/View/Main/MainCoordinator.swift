//
//  MainCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 21/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation
import ShareKit
import FirebaseCore
import Spotify

final class MainCoordinator {
    
    typealias LaunchingResult = (result: Bool, window: UIWindow)
    private let tabInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    
    private lazy var spotifyAuth: SPTAuth = {
        let auth = SPTAuth.defaultInstance()!
        auth.clientID = "c5b394d7cb5a4ac6a522cb6dc3367627"
        auth.redirectURL = URL(string: "embassat-login://callback")
        auth.sessionUserDefaultsKey = "current session"
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        return auth
    }()
    
    private lazy var rootViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [self.infoTab, self.artistsTab, self.scheduleTab, self.spotifyTab]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundImage = UIImage.tabBackgroundImage(
            with: CGSize(width: 1,
                         height: tabBarController.tabBar.bounds.height)
        )
        
        return tabBarController
    }()
    
    private lazy var infoTab: RootNavigationController = {
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
        infoNavigationController.tabBarItem.imageInsets = self.tabInsets
        
        return infoNavigationController
    }()
    
    private lazy var artistsTab: RootNavigationController = {
        let artistsInteractor = ArtistsInteractor()
        let artistsCoordinator = ArtistsCoordinator()
        let artistsViewController = ArtistsViewController(binding: artistsInteractor) { (interactor, _) in
            return ArtistsViewModel(interactor: interactor, coordinator: artistsCoordinator)
        }
        let artistsNavigationController = RootNavigationController(rootViewController: artistsViewController)
        artistsNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabArtists, selectedImage: UIImage.tabArtistsSelected)
        artistsNavigationController.tabBarItem.imageInsets = self.tabInsets
        artistsCoordinator.viewController = artistsViewController
        
        return artistsNavigationController
    }()
    
    private lazy var scheduleTab: RootNavigationController = {
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
        scheduleNavigationController.tabBarItem.imageInsets = self.tabInsets
        
        return scheduleNavigationController
    }()
    
    private lazy var spotifyTab: RootNavigationController = {
        let spotifyInteractor = SpotifyInteractor(auth: self.spotifyAuth)
        let spotifyViewController = SpotifyViewController(binding: spotifyInteractor) { (interactor, _) in
            return SpotifyViewModel(interactor: interactor)
        }
        let spotifyNavigationController = RootNavigationController(rootViewController: spotifyViewController)
        spotifyNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabSpotify, selectedImage: UIImage.tabSpotifySelected)
        spotifyNavigationController.tabBarItem.imageInsets = self.tabInsets
        
        return spotifyNavigationController
    }()
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> LaunchingResult {
        registerServices()
        setupAppearance()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return (true, window)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SHKFacebook.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SHKFacebook.handleWillTerminate()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?) -> Bool {
        
        if spotifyAuth.canHandle(url) {
            spotifyAuth.handleAuthCallback(withTriggeredAuthURL: url) { [weak self] (error, session) in
                if let _ = session,
                   let spotifyViewController = self?.spotifyTab.viewControllers.first as? SpotifyViewController {
                    spotifyViewController.handleAuthCallback()
                }
            }
            
            return true
        }
        
        guard let scheme = url.scheme else { return false }
        
        if scheme.hasPrefix("fb\(SHKConfiguration.sharedInstance().configurationValue("facebookAppId", with: nil))") {
            return SHKFacebook.handleOpen(url, sourceApplication: sourceApplication)
        }
        
        return false
    }
    
    // MARK: - Private
    
    private func registerServices() {
        FirebaseApp.configure()
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
}
