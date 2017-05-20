//
//  ArtistsInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

final class ArtistsInteractor: Interactor {
    
    var modelDidUpdate: (([CADEMArtist]) -> ())?
    
    fileprivate(set) var model: [CADEMArtist] = [] {
        didSet {
            modelDidUpdate?(model)
        }
    }
    
    fileprivate let service = ArtistService()
    
    func fetchArtists() {
        service.persistedArtists { [weak self] (artists) in
            self?.updateArtists(withArtists: artists)
        }
        
        service.artists { [weak self] (artists, error) in
            guard let artists = artists, error == nil else { return }
            self?.updateArtists(withArtists: artists)
        }
    }
    
    fileprivate func updateArtists(withArtists artists: [CADEMArtist]) {
        model = artists.sorted{ $0.name < $1.name }
    }
}
