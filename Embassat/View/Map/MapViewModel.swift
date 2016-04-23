//
//  MapViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

struct MapViewModel {
    
    func numberOfPoints() -> Int {
        return 8
    }
    
    func latitudeForPoint(atIndex index: Int) -> Double {
        let latitudes = [41.553602, 41.554052, 41.545738, 41.545971, 41.548604, 41.5455645, 41.5417171, 41.5466157]
        
        return latitudes[index]
    }
    
    func longitudeForPoint(atIndex index: Int) -> Double {
        let longitudes = [2.099773, 2.099800, 2.106824, 2.11322, 2.10881, 2.1046665, 2.0969444, 2.1067646]
        
        return longitudes[index]
    }
    
    func titleForPoint(atIndex index: Int) -> String {
        let titles = ["Escenari Principal", "Yeearphone", "Mirador Museu del Gas", "Kräsna", "Balboa", "Museu del Gas", "Can Marcet", "Pç del Dr Robert"]
        
        return titles[index]
    }
    
}