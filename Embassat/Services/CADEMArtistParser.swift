//
//  CADEMArtistParser.swift
//  Embassa't
//
//  Created by Joan Romano on 15/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

import SwiftyJSON

public class CADEMArtistParser: NSObject {
    
    let dateFormatter: NSDateFormatter
    
    override init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    public func parseArtists(fromJson json: AnyObject, cached cachedArtists: Array<CADEMArtist> = []) -> Array<CADEMArtist> {
        var artists: [CADEMArtist] = []
        for (_,subJson):(String, JSON) in JSON(json) {
            
            guard let startDate = dateFormatter.dateFromString(subJson["start_date"].stringValue),
                  let endDate = dateFormatter.dateFromString(subJson["start_date"].stringValue) else {
                    break;
            }
            
            var favorited = false
            
            if let existingArtist = cachedArtists.filter({ (artist: CADEMArtist) -> Bool in
                return artist.artistId == subJson["id"].intValue
            }).first {
                favorited = existingArtist.favorite
            }

            let artist = CADEMArtist(
                artistId: subJson["id"].intValue,
                name: subJson["name"].stringValue,
                longDescription: subJson["description"].stringValue,
                artistURL: NSURL(string: subJson["share_url"].stringValue)!,
                imageURL: NSURL(string: subJson["image_url"].stringValue)!,
                startDate: startDate,
                endDate: endDate,
                stage: subJson["stage"].stringValue,
                favorite: favorited
            )
            artists.append(artist)
        }
        
        return artists
    }
}