//
//  CADEMArtist.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

open class CADEMArtist : NSObject, NSCoding {
    let artistId: Int
    let name: String
    let longDescription: String
    let stage: String
    let youtubeId: String
    let artistURL: URL
    let imageURL: URL
    let startDate: Date
    let endDate: Date
    let scheduleDate: Date
    let scheduleDayString: String
    
    var favorite: Bool
    
    init(artistId: Int, name: String, longDescription: String, artistURL: URL, imageURL: URL, startDate: Date, endDate: Date, stage: String, youtubeId: String, favorite: Bool = false) {
        self.artistId = artistId
        self.name = name
        self.longDescription = longDescription
        self.artistURL = artistURL
        self.imageURL = imageURL
        self.startDate = startDate
        self.endDate = endDate
        self.stage = stage
        self.youtubeId = youtubeId
        self.favorite = favorite    
        self.scheduleDate = startDate.hour < 10 ? startDate.dateBySubstracting(days: 1) : startDate
        self.scheduleDayString = scheduleDate.day == 9 ? "Dijous" : scheduleDate.day == 10 ? "Divendres" : scheduleDate.day == 11 ? "Dissabte" : "Diumenge"
    }
    
    required convenience public init(coder decoder: NSCoder) {
        self.init(artistId: decoder.decodeInteger(forKey: "artistId"),
                  name: decoder.decodeObject(forKey: "name") as! String,
                  longDescription: decoder.decodeObject(forKey: "longDescription") as! String,
                  artistURL: decoder.decodeObject(forKey: "artistURL") as! URL,
                  imageURL: decoder.decodeObject(forKey: "imageURL") as! URL,
                  startDate: decoder.decodeObject(forKey: "startDate") as! Date,
                  endDate: decoder.decodeObject(forKey: "endDate") as! Date,
                  stage: decoder.decodeObject(forKey: "stage") as! String,
                  youtubeId: decoder.decodeObject(forKey: "youtubeId") as! String,
                  favorite: decoder.decodeBool(forKey: "favorite"))
    }
    
    open func encode(with coder: NSCoder) {
        coder.encode(artistId, forKey: "artistId")
        coder.encode(name, forKey: "name")
        coder.encode(longDescription, forKey: "longDescription")
        coder.encode(stage, forKey: "stage")
        coder.encode(youtubeId, forKey: "youtubeId")
        coder.encode(artistURL, forKey: "artistURL")
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(endDate, forKey: "endDate")
        coder.encode(favorite, forKey: "favorite")
    }
    
    override open var description: String {
        return "Artist: \(name), id \(artistId), description\(longDescription), favorited? \(favorite)"
    }
}
