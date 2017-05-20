//
//  ArtistsViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistsViewModel: ViewModelCollectionDelegate, CoordinatedViewModel {
    
    let interactor: ArtistsInteractor
    let coordinator: ArtistsCoordinator
    let artists: [CADEMArtist]
    
    required init(interactor: ArtistsInteractor, coordinator: ArtistsCoordinator) {
        self.artists = interactor.model
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    func numberOfItemsInSection(_ section : Int) -> Int {
        return artists.count
    }
    
    func shouldRefreshModel() {
        interactor.fetchPersistedArtists()
    }
    
    func titleAtIndexPath(_ indexPath: IndexPath) -> String {
        return artists[indexPath.row].name.uppercased()
    }
    
    func shouldHideSeparator(forIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == numberOfItemsInSection(0) - 1
    }
    
    func didSelect(at index: Int) {
        coordinator.presentArtistDetail(interactor.model, currentIndex: index)
    }
}
