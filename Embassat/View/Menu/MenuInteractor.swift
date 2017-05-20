//
//  MenuInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 25/07/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

class MenuInteractor: Interactor {
    
    var updateHandler: (([String]) -> ())?
    
    fileprivate(set) var model: [String] = ["Info", "Artistes", "Horaris", "Petit EM'", "Transport", "Mapa", "Entrades", "Playlist"]
}
