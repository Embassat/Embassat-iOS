//
//  ArtistDetailCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation
import EventKit
import ShareKit

class ArtistDetailCoordinator: Coordinator {
    weak var viewController: ArtistDetailViewController?
    
    func showShareAction(withURL URL: NSURL, title: String) {
        let item: AnyObject! = SHKItem.URL(URL, title: title, contentType: SHKURLContentTypeUndefined)
        
        SHK.setRootViewController(viewController)
        let alertController = SHKAlertController.actionSheetForItem(item as! SHKItem)
        alertController.modalPresentationStyle = .Popover
        let popover = alertController.popoverPresentationController
        popover?.barButtonItem = viewController?.toolbarItems?.first
        viewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}