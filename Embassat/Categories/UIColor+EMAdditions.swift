//
//  UIColor+EMAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func emBarTintColor() -> UIColor {
        return .blackColor()
    }
    
    class func emBackgroundColor() -> UIColor {
        return .blackColor()
    }
    
    class func emSelectedColor() -> UIColor {
        return .whiteColor()
    }
    
    class func emBackgroundSelectedColor() -> UIColor {
        return .whiteColor()
    }
    
    class func emBackgroundDeselectedColor() -> UIColor {
        return UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    }
    
    class func emScheduleHeaderSelectedBackgroundColor() -> UIColor {
        return .whiteColor()
    }
    
    class func emScheduleHeaderSelectedTextColor() -> UIColor {
        return .blackColor()
    }
    
    class func emScheduleHeaderDeselectedBackgroundColor() -> UIColor {
        return blackColor()
    }
    
    class func emScheduleHeaderDeselectedTextColor() -> UIColor {
        return .whiteColor()
    }
}
