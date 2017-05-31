//
//  SpotifyViewModel.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

final class SpotifyViewModel: ViewModelCollectionDelegate {
    
    private let interactor: SpotifyInteractor
    private let model: [SpotifyTrack]
    
    var clientId: String {
        return interactor.auth.clientID
    }
    
    var accessToken: String {
        return interactor.auth.session.accessToken
    }
    
    var isSessionValid: Bool {
        guard let session = interactor.auth.session else { return false }
        
        return session.isValid()
    }
    
    var shouldShowContent: Bool {
        return model.count > 0
    }
    
    var authURL: URL {
        return interactor.auth.spotifyWebAuthenticationURL()
    }

    init(interactor: SpotifyInteractor) {
        self.interactor = interactor
        self.model = interactor.model
    }
    
    func playableURIAtIndexPath(_ indexPath: IndexPath) -> String {
        return model[indexPath.row].playableURI
    }
    
    func titleAtIndexPath(_ indexPath: IndexPath) -> String {
        let track = model[indexPath.row]
        return "\(track.name) - \(track.artist)"
    }
    
    func shouldHideSeparator(forIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == numberOfItemsInSection(0) - 1
    }
    
    func shouldPlayNextSong(forIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.item + 1 < model.count
    }
    
    func fetchTracks() {
        interactor.fetchTracks()
    }
    
    // MARK: - ViewModelCollectionDelegate
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return model.count
    }
}
