//
//  SpotifyInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit
import Spotify

final class SpotifyInteractor: Interactor {
    
    var modelDidUpdate: ((String) -> ())?
    
    fileprivate(set) var model: String = "" {
        didSet {
            modelDidUpdate?(model)
        }
    }
    
    let auth: SPTAuth
    
    init(auth: SPTAuth) {
        self.auth = auth
    }

}
