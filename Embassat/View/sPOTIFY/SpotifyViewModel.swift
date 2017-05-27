//
//  SpotifyViewModel.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

final class SpotifyViewModel {
    
    let interactor: SpotifyInteractor

    init(interactor: SpotifyInteractor) {
        self.interactor = interactor
    }
    
    var clientId: String {
        return interactor.auth.clientID
    }
    
    var accessToken: String {
        return interactor.auth.session.accessToken
    }
    
    var isSessionValid: Bool {
        return interactor.auth.session.isValid()
    }
    
    var authURL: URL {
        return interactor.auth.spotifyWebAuthenticationURL()
    }
}
