//
//  ArtistDetailInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistDetailInteractor: Interactor {
    
    var updateHandler: ((CADEMArtist) -> ())?
    
    private(set) var model: CADEMArtist
    
    private var artists: [CADEMArtist]
    private let service = ArtistService()
    
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex > artists.count - 1 {
                currentIndex = artists.count - 1
            }
            
            if currentIndex < 0 {
                currentIndex = 0
            }
            
            model = artists[currentIndex]
            updateHandler?(model)
        }
    }
    
    required init(artists: [CADEMArtist], index: Int) {
        self.artists = artists
        self.currentIndex = index
        self.model = artists[index]
    }
    
    func toggleFavorite() {
        service.toggleFavorite(forArtist: artists[currentIndex]) { [weak self] (artist) in
            guard let strongSelf = self else { return }
            
            strongSelf.artists[strongSelf.currentIndex] = artist
            strongSelf.model = artist
            strongSelf.updateHandler?(strongSelf.model)
        }
    }
}
