//
//  ArtistsInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistsInteractor: Interactor {
    
    var updateHandler: (([CADEMArtist]) -> ())?
    
    private(set) var model: [CADEMArtist] = []
    
    private let service = ArtistService()
    
    func fetchArtists() {
        service.artists { [weak self] (artists, error) in
            guard let artists = artists where error == nil else { return }
            self?.updateArtists(withArtists: artists)
        }
    }
    
    func fetchCachedArtists() {
        service.cachedArtists { [weak self] (artists) in
            self?.updateArtists(withArtists: artists)
        }
    }
    
    private func updateArtists(withArtists artists: [CADEMArtist]) {
        model = artists.sort{ $0.name < $1.name }
        updateHandler?(model)
    }
}
