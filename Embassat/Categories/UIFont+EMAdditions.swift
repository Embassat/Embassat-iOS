//
//  UIFont+EMAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import Foundation

extension UIFont {    
    class func detailFont(ofSize size: Float) -> UIFont? {
        return UIFont(name: "Apercu-Medium", size: CGFloat(size))
    }
    
    class func titleFont(ofSize size: Float) -> UIFont? {
        return UIFont(name: "NoeDisplay-Bold", size: CGFloat(size))
    }
}
