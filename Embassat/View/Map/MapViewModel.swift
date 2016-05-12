//
//  MapViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

struct MapViewModel {
    
    let latitudes = [41.545738, 41.5417171, 41.54164, 41.5466157]
    let longitudes = [2.106824, 2.0969444, 2.096826, 2.1067646]
    let titles = ["Mirador Museu del Gas", "Can Marcet - Escenari Principal", "Can Marcet - Yeearphone", "Pl. Dr. Robert"]
    
    func numberOfPoints() -> Int {
        return latitudes.count
    }
    
    func latitudeForPoint(atIndex index: Int) -> Double {
        return latitudes[index]
    }
    
    func longitudeForPoint(atIndex index: Int) -> Double {
        return longitudes[index]
    }
    
    func titleForPoint(atIndex index: Int) -> String {
        return titles[index]
    }
    
}