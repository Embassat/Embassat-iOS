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
    
    init(artists: [CADEMArtist], index: Int, service: ArtistServiceProtocol)
    func toggleFavorite()
    func nextArtist()
    func previousArtist()
}

class ArtistDetailInteractor: ArtistDetailInteractorProtocol {
    
    /** The interactor's update handler */
    var updateHandler: ((CADEMArtist) -> ())?
    
    /** The interactor's model */
    fileprivate(set) var model: CADEMArtist
    
    /** An ArtistServiceProtocol to perform actions on the model. */
    let service: ArtistServiceProtocol
    
    fileprivate var artists: [CADEMArtist]
    
    /**
     Initializes a new ArtistDetailInteractor.
     
     - parameter artists: An array of CADEMArtist.
     - parameter index: The index of the current artist.
     - parameter service: An ArtistServiceProtocol to perform actions on the model.
     */
    required init(artists: [CADEMArtist], index: Int, service: ArtistServiceProtocol) {
        self.artists = artists
        self.model = artists[index]
        self.service = service
    }
    
    /** Fetches the next artist and updates the model, calling the update handler */
    func nextArtist() {
        guard let index = artists.index(of: model) else { return }
        
        updateModel(withNexIndex: index + 1)
    }
    
    /** Fetches the previous artist and updates the model, calling the update handler */
    func previousArtist() {
        guard let index = artists.index(of: model) else { return }
        
        updateModel(withNexIndex: index - 1)
    }
    
    /** Toggles the favorite state of the model/artist */
    func toggleFavorite() {
        service.toggleFavorite(forArtist: model) { [weak self] (artist) in
            guard let strongSelf = self, let index = strongSelf.artists.index(of: strongSelf.model) else { return }
            
            strongSelf.artists[index] = artist
            strongSelf.model = artist
            strongSelf.updateHandler?(strongSelf.model)
        }
    }
    
    private func updateModel(withNexIndex index: Int) {
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
}
