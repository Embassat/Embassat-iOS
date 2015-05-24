//
//  CADEMArtistParser.swift
//  Embassa't
//
//  Created by Joan Romano on 15/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistParser: NSObject {
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    public func parseArtists(fromJson json: AnyObject, cached cachedArtists: Array<CADEMArtistSwift> = []) -> Array<CADEMArtistSwift> {
        var artists: [CADEMArtistSwift] = []
        for (index: String, subJson: JSON) in JSON(json) {
            var longDescr = ""
            var favorited = false
            
            if let longDesc = subJson["content"].stringValue.scanStringWithStartTag("<p>", endTag: "</p>") {
                longDescr = longDesc
            }
            if let existingArtist = cachedArtists.filter({ (artist: CADEMArtistSwift) -> Bool in
            return artist.artistId == subJson["ID"].intValue
            }).first {
                favorited = existingArtist.favorite
            }

            let artist = CADEMArtistSwift(
                artistId: subJson["ID"].intValue,
                name: subJson["title"].stringValue,
                longDescription: longDescr,
                artistURL: NSURL(string: subJson["e"].stringValue)!,
                imageURL: NSURL(string: subJson["featured_image"]["attachment_meta"]["sizes"]["large"]["url"].stringValue)!,
                date: self.dateFormatter.dateFromString(subJson["date"].stringValue)!,
                stage: subJson["terms"]["portfolio_category"][0]["name"].stringValue,
                favorite: favorited
            )
            artists.append(artist)
        }
        
        return artists
    }
}