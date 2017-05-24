//
//  UIImage.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import Foundation

extension UIImage {
    
    // Creates an image of the given size filled with the given color.
    // http://stackoverflow.com/a/39604716/1300959
    static func withColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    class var tabInfo: UIImage {
        return UIImage(named: "tabInfo")!
    }
    
    class var tabInfoSelected: UIImage {
        return UIImage(named: "tabInfoSelected")!.withRenderingMode(.alwaysOriginal)
    }
    
    class var tabArtists: UIImage {
        return UIImage(named: "tabArtists")!
    }
    
    class var tabArtistsSelected: UIImage {
        return UIImage(named: "tabArtistsSelected")!.withRenderingMode(.alwaysOriginal)
    }
    
    class var tabSchedule: UIImage {
        return UIImage(named: "tabSchedule")!
    }
    
    class var tabScheduleSelected: UIImage {
        return UIImage(named: "tabScheduleSelected")!.withRenderingMode(.alwaysOriginal)
    }
    
    class func tabBackgroundImage(with size: CGSize) -> UIImage {
        return UIImage.withColor(color: UIColor.primary.withAlphaComponent(0.95), size: size)
    }
    
    class var loading: UIImage {
        return UIImage(named: "loading")!
    }
    
    class var favorite: UIImage {
        return UIImage(named: "fav")!
    }
    
    class var chevron: UIImage {
        return UIImage(named: "chevron")!
    }
    
    class var share: UIImage {
        return UIImage(named: "share.png")!
    }
}
