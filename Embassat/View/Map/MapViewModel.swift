//
//  MapViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

final class MapViewModel {
    
    let interactor: MapInteractor
    let model: MapFields
    
    fileprivate var didTrackUserLocation = false
    
    required init(interactor: MapInteractor) {
        self.model = interactor.model
        self.interactor = interactor
    }
    
    func numberOfPoints() -> Int {
        return model.latitudes.count
    }
    
    func latitudeForPoint(atIndex index: Int) -> Double {
        return model.latitudes[index]
    }
    
    func longitudeForPoint(atIndex index: Int) -> Double {
        return model.longitudes[index]
    }
    
    func titleForPoint(atIndex index: Int) -> String {
        return model.titles[index]
    }
    
    func shouldUpdateVisibleRect() -> Bool {
        if !didTrackUserLocation {
            didTrackUserLocation = true
            return true
        } else {
            return false
        }
    }
    
}
