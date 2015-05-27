//
//  CADEMMapViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMMapViewModel: NSObject {
    
    public func numberOfPoints() -> Int {
        return 5
    }
    
    public func latitudeForPoint(atIndex index: Int) -> Double {
        let latitudes: Dictionary<Int, Double> = [0 : 41.546838, 1 : 41.547213, 2 : 41.545738, 3 : 41.545971, 4 : 41.548604]
        
        return latitudes[index]!
    }
    
    public func longitudeForPoint(atIndex index: Int) -> Double {
        let longitudes: Dictionary<Int, Double> = [0 : 2.106158, 1 : 2.106564, 2 : 2.106824, 3 : 2.11322, 4 : 2.10881]
        
        return longitudes[index]!
    }
    
    public func titleForPoint(atIndex index: Int) -> String {
        let titles: Dictionary<Int, String> = [0 : "Escenari Principal", 1 : "Amfiteatre", 2 : "Mirador Museu del Gas", 3 : "Kräsna", 4 : "Balboa"]
        
        return titles[index]!
    }
    
}