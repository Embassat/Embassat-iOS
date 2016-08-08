//
//  ArtistDetailInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

protocol ArtistDetailInteractorProtocol: Interactor {
    associatedtype ModelType = CADEMArtist
    
    init(artists: [CADEMArtist], index: Int)
    func toggleFavorite()
    func currentIndex() -> Int
    func updateModel(withNexIndex index: Int)
}

class ArtistDetailInteractor: ArtistDetailInteractorProtocol {
    
    var updateHandler: ((CADEMArtist) -> ())?
    
    private(set) var model: CADEMArtist
    
    private var artists: [CADEMArtist]
    private let service = ArtistService()
    
    required init(artists: [CADEMArtist], index: Int) {
        self.artists = artists
        self.model = artists[index]
    }
    
    func currentIndex() -> Int {
        return artists.indexOf(model)!
    }
    
    func updateModel(withNexIndex index: Int) {
        var theIndex: Int = index
        
        if theIndex > artists.count - 1 {
            theIndex = artists.count - 1
        }
        
        if theIndex < 0 {
            theIndex = 0
        }
        
        model = artists[theIndex]
        updateHandler?(model)
    }
    
    func toggleFavorite() {
        service.toggleFavorite(forArtist: model) { [weak self] (artist) in
            guard let strongSelf = self, index = strongSelf.artists.indexOf(artist) else { return }
            
            strongSelf.artists[index] = artist
            strongSelf.model = artist
            strongSelf.updateHandler?(strongSelf.model)
        }
    }
}
