//
//  MenuCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 25/07/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

enum MenuIndex: Int {
    case Info
    case Artists
    case Schedule
    case PetitEM
    case Transport
    case Map
    case Tickets
    case Playlist
}

class MenuCoordinator: Coordinator {
    
    weak var viewController: MenuViewController?
    
    func show(nextViewControllerWithIndex index: MenuIndex) {
     
        var nextViewController: UIViewController?
        
        switch index {
        case .Info:
            nextViewController = InfoViewController()
            break;
            
        case .Artists:
            nextViewController = ArtistsViewController()
            break;
            
        case .Schedule:
            nextViewController = ScheduleViewController(ScheduleViewModel())
            break;
            
        case .PetitEM:
            nextViewController = PetitEMViewController()
            break;
            
        case .Transport:
            nextViewController = TransportViewController()
            break;
            
        case .Map:
            nextViewController = MapViewController(MapViewModel())
            break;
            
        case .Tickets:
            nextViewController = TicketsViewController()
            break;
            
        case .Playlist:
            nextViewController = nil
            let normalURL = NSURL(string: "http://open.spotify.com/user/embassat/playlist/16SGgn6bS6uQnImxWzZfrc")!
            let appURL = NSURL(string: "spotify://user:embassat")!
            //:playlist:16SGgn6bS6uQnImxWzZfrc
            if UIApplication.sharedApplication().openURL(appURL) == false {
                UIApplication.sharedApplication().openURL(normalURL)
            }
            
            break;
        }
        
        if let nextViewController = nextViewController {
            viewController?.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}