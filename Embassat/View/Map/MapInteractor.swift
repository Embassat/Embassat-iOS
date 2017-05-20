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

class MapInteractor: Interactor {
    
    var updateHandler: ((MapFields) -> ())?
    
    fileprivate(set) var model = MapFields(latitudes: [41.545738, 41.5417171, 41.5466157, 41.5468636],
                                       longitudes: [2.106824, 2.0969444, 2.1067646, 2.1035644],
                                       titles: ["Mirador Museu del Gas", "Can Marcet", "Pl. Dr. Robert", "Sala Oui!"])
    
}
