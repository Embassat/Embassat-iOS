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

protocol ArtistDetailCoordinatorProtocol: Coordinator {
    func showShareAction(withURL URL: URL, title: String)
    
    weak var viewController: ArtistDetailViewController? { get set }
}

final class ArtistDetailCoordinator: ArtistDetailCoordinatorProtocol {
    weak var viewController: ArtistDetailViewController?
    
    func showShareAction(withURL URL: Foundation.URL, title: String) {
        guard let item = SHKItem.url(URL, title: title, contentType: SHKURLContentTypeUndefined) as? SHKItem,
              let alertController = SHKAlertController.actionSheet(for: item)  else { return }
        
        SHK.setRootViewController(viewController)
        alertController.modalPresentationStyle = .popover
        let popover = alertController.popoverPresentationController
        popover?.barButtonItem = viewController?.toolbarItems?.first
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
