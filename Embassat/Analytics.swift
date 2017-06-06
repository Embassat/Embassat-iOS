//
//  Analytics.swift
//  Embassat
//
//  Created by Joan Romano on 27/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum Analytics {
    
    enum Action: String {
        case screen
        case share
        case favourite
    }
    
    enum Screen: String {
        case artists
        case artistDetail
        case info
        case map
        case schedule
        case tickets
        case transport
        case playlist
    }
    
    static func trackAction(_ action: Action, parameters: [String : Any]?) {
        FirebaseAnalytics.Analytics.logEvent(action.rawValue, parameters: parameters)
    }
    
    static func trackScreenView(_ screen: Screen, parameters: [String : Any]? = nil) {
        var params: [String : Any] = ["screen_name" : screen.rawValue]
        if let parameters = parameters { params += parameters }
        trackAction(.screen, parameters: params)
    }
}

fileprivate func +=<U,T>(lhs: inout [U:T], rhs: [U:T]) {
    for (key, value) in rhs {
        lhs[key] = value
    }
}
