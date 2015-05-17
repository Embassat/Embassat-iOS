//
//  CADArtistParser.swift
//  Embassa't
//
//  Created by Joan Romano on 15/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADArtistParser: NSObject {
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    public func parseArtists(fromJson json: AnyObject) -> Array<CADEMArtistSwift> {
        var artists: [CADEMArtistSwift] = []
        for (index: String, subJson: JSON) in JSON(json) {
            let artist = CADEMArtistSwift(
                name: subJson["title"].stringValue,
                longDescription: subJson["content"].stringValue,
                artistURL: NSURL(string: subJson["link"].stringValue)!,
                imageURL: NSURL(string: subJson["featured_image"]["attachment_meta"]["sizes"]["large"]["url"].stringValue)!,
                date: self.dateFormatter.dateFromString(subJson["date"].stringValue)!,
                stage: subJson["terms"]["portfolio_category"][0]["name"].stringValue
            )
            artists.append(artist)
        }
        
        return artists
    }
}