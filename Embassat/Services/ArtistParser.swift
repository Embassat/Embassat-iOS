//
//  ArtistParser.swift
//  Embassa't
//
//  Created by Joan Romano on 15/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

import SwiftyJSON

struct ArtistParser {
    
    let dateFormatter: NSDateFormatter
    
    init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func parseArtists(fromJson json: AnyObject, cached cachedArtists: [CADEMArtist] = []) -> [CADEMArtist] {
        var artists: [CADEMArtist] = []
        for (_,subJson):(String, JSON) in JSON(json) {
            
            guard let startDate = dateFormatter.dateFromString(subJson["start_date"].stringValue),
                  let endDate = dateFormatter.dateFromString(subJson["end_date"].stringValue) else {
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
                artistURL: NSURL(string: subJson["share_url"].stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? "")!,
                imageURL: NSURL(string: subJson["image_url"].stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? "")!,
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