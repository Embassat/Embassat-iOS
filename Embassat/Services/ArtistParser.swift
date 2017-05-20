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
    
    let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func parseArtists(fromJson json: AnyObject, cached cachedArtists: [CADEMArtist] = []) -> [CADEMArtist] {
        var artists: [CADEMArtist] = []
        for (_,subJson):(String, JSON) in JSON(json) {
            
            guard let startDate = dateFormatter.date(from: subJson["start_date"].stringValue),
                  let endDate = dateFormatter.date(from: subJson["end_date"].stringValue) else {
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
                artistURL: URL(string: subJson["share_url"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!,
                imageURL: URL(string: subJson["image_url"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!,
                startDate: startDate,
                endDate: endDate,
                stage: subJson["stage"].stringValue,
                youtubeId: subJson["youtube_video_id"].stringValue,
                favorite: favorited
            )
            artists.append(artist)
        }
        
        return artists
    }
}
