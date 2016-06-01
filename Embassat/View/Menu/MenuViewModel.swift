//
//  MenuViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class MenuViewModel: NSObject, ViewModelCollectionDelegate {
    
    let model: [String]
    
    init(model : [String]) {
        self.model = model
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return self.model.count
    }
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.model[indexPath.row]
    }
    
    func nextViewControllerAtIndexPath(indexPath: NSIndexPath) -> UIViewController? {
        
        var viewController: UIViewController?
        
        switch indexPath.item {
        case 0:
            viewController = InfoViewController()
            break;
            
        case 1:
            viewController = ArtistsViewController()
            break;
            
        case 2:
            viewController = ScheduleViewController(ScheduleViewModel())
            break;
            
        case 3:
            viewController = PetitEMViewController()
            break;
            
        case 4:
            viewController = TransportViewController()
            break;
            
        case 5:
            viewController = MapViewController(MapViewModel())
            break;
            
        case 6:
            viewController = TicketsViewController()
            break;
            
        case 7:
            viewController = nil
            let normalURL = NSURL(string: "http://open.spotify.com/user/embassat/playlist/16SGgn6bS6uQnImxWzZfrc")!
            let appURL = NSURL(string: "spotify://user:embassat")!
            //:playlist:16SGgn6bS6uQnImxWzZfrc
            if UIApplication.sharedApplication().openURL(appURL) == false {
                UIApplication.sharedApplication().openURL(normalURL)
            }
            
            break;
            
        default:
            break;
        }

        return viewController
    }

}
