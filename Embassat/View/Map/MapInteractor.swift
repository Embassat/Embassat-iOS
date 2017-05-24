//
//  MapInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 02/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

struct MapFields {
    let latitudes: [Double]
    let longitudes: [Double]
    let titles: [String]
}

final class MapInteractor: Interactor {
    
    var modelDidUpdate: ((MapFields) -> ())?
    
    fileprivate(set) var model = MapFields(latitudes: [41.5417171],
                                           longitudes: [2.0969444],
                                           titles: ["Can Marcet"])
    
}
