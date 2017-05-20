//
//  MenuCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 25/07/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

enum MenuIndex: Int {
    case info
    case artists
    case schedule
    case petitEM
    case transport
    case map
    case tickets
    case playlist
}

class MenuCoordinator: Coordinator {
    
    weak var viewController: MenuViewController?
    
    func show(nextViewControllerWithIndex index: MenuIndex) {
     
        var nextViewController: UIViewController?
        
        switch index {
        case .info:
            nextViewController = InfoViewController()
            break;
            
        case .artists:
            let interactor = ArtistsInteractor()
            let coordinator = ArtistsCoordinator()
            let viewModel = ArtistsViewModel(interactor: interactor, coordinator: coordinator)
            let viewController = ArtistsViewController(viewModel: viewModel)
            viewController.bind(to: interactor)
            coordinator.viewController = viewController
            interactor.fetchArtists()
            nextViewController = viewController
            break;
            
        case .schedule:
            let interactor = ScheduleInteractor()
            let coordinator = ScheduleCoordinator()
            let viewModel = ScheduleViewModel(interactor: interactor, coordinator: coordinator)
            let viewController = ScheduleViewController(viewModel: viewModel)
            viewController.bind(to: interactor)
            coordinator.viewController = viewController
            interactor.fetchArtists()
            nextViewController = viewController
            break;
            
        case .petitEM:
            nextViewController = PetitEMViewController()
            break;
            
        case .transport:
            nextViewController = TransportViewController()
            break;
            
        case .map:
            let interactor = MapInteractor()
            let viewModel = MapViewModel(interactor: interactor)
            let viewController = MapViewController(viewModel: viewModel)
            viewController.bind(to: interactor)
            nextViewController = viewController
            break;
            
        case .tickets:
            nextViewController = TicketsViewController()
            break;
            
        case .playlist:
            nextViewController = nil
            let normalURL = URL(string: "http://open.spotify.com/user/embassat/playlist/16SGgn6bS6uQnImxWzZfrc")!
            let appURL = URL(string: "spotify://user:embassat")!
            //:playlist:16SGgn6bS6uQnImxWzZfrc
            if UIApplication.shared.openURL(appURL) == false {
                UIApplication.shared.openURL(normalURL)
            }
            
            break;
        }
        
        if let nextViewController = nextViewController {
            viewController?.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
