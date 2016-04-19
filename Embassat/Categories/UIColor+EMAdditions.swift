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
        return UIColor(red: 44.0/255.0, green: 56.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    }
    
    class func emBackgroundColor() -> UIColor {
        return UIColor(red: 237.0/255.0, green: 42.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    }
    
    class func emSelectedColor() -> UIColor {
        return UIColor(red: 239.0/255.0, green: 196.0/255.0, blue: 0, alpha: 1.0)
    }
    
    class func emBackgroundDeselectedColor() -> UIColor {
        return UIColor(red: 0.0, green: 2.0/255.0, blue: 33.0/255.0, alpha: 1.0)
    }
    
    class func emScheduleHeaderBackgroundColor() -> UIColor {
        return emBackgroundColor()
    }
    
    class func emScheduleHeaderDeselectedBackgroundColor() -> UIColor {
        return emSelectedColor()
    }
    
    class func emScheduleHeaderDeselectedTextColor() -> UIColor {
        return UIColor(red: 240.0/255.0, green: 81.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    }
}
