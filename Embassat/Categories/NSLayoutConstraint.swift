//
//  NSLayoutConstraint.swift
//  Embassat
//
//  Created by Joan Romano on 21/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
    /// Activates an array of constraints and sets `translatesAutoresizingMaskIntoConstraints` for their first items
    ///
    /// - Parameter constraints: an array of `NSLayoutConstraint`
    class func useAndActivate(_ constraints: [NSLayoutConstraint]) {
        
        constraints.forEach { ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false }
        
        activate(constraints)
    }
}
