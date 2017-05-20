//
//  ScheduleCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

final class ScheduleCoordinator: Coordinator {
    weak var viewController: ScheduleViewController?
    
    func presentArtistDetail(_ artists: [CADEMArtist], currentIndex: Int) {
        let interactor = ArtistDetailInteractor(artists: artists, index: currentIndex, service: ArtistService())
        let coordinator = ArtistDetailCoordinator()
        let artistDetailViewController = ArtistDetailViewController(binding: interactor) { (interactor, _) in
            return ArtistDetailViewModel(interactor: interactor, coordinator: coordinator)
        }
        
        coordinator.viewController = artistDetailViewController
        viewController?.navigationController?.pushViewController(artistDetailViewController, animated: true)
    }
}
