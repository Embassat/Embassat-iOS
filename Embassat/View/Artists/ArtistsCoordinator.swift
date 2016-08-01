//
//  ArtistsCoordinator.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistsCoordinator: Coordinator {
    weak var viewController: ArtistsViewController?
    
    func presentArtistDetail(artists: [CADEMArtist], currentIndex: Int) {
        let artistDetailViewController = ArtistDetailViewController()
        let viewModel = ArtistDetailViewModel(model: artists, currentIndex: currentIndex)
        artistDetailViewController.viewModel = viewModel
        viewController?.navigationController?.pushViewController(artistDetailViewController, animated: true)
    }
}
