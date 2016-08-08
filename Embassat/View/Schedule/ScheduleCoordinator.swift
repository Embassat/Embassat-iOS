//
//  ScheduleCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

class ScheduleCoordinator: Coordinator {
    weak var viewController: ScheduleViewController?
    
    func presentArtistDetail(artists: [CADEMArtist], currentIndex: Int) {
        let interactor = ArtistDetailInteractor(artists: artists, index: currentIndex)
        let coordinator = ArtistDetailCoordinator()
        let viewModel = ArtistDetailViewModel<ArtistDetailCoordinator, ArtistDetailInteractor>(interactor: interactor, coordinator: coordinator)
        let artistDetailViewController = ArtistDetailViewController(viewModel: viewModel)
        artistDetailViewController.bind(to: interactor)
        coordinator.viewController = artistDetailViewController
        
        viewController?.navigationController?.pushViewController(artistDetailViewController, animated: true)
    }
}
