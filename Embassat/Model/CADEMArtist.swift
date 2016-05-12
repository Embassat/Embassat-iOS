//
//  CADEMArtist.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtist : NSObject, NSCoding {
    let artistId: Int
    let name: String
    let longDescription: String
    let stage: String
    let youtubeId: String
    let artistURL: NSURL
    let imageURL: NSURL
    let startDate: NSDate
    let endDate: NSDate
    let scheduleDate: NSDate
    let scheduleDayString: String
    
    var favorite: Bool
    
    var isFree: Bool {
        get {
            return scheduleDate.day == 9 || (startDate.hour > 10 && startDate.hour < 17)
        }
    }
    
    init(artistId: Int, name: String, longDescription: String, artistURL: NSURL, imageURL: NSURL, startDate: NSDate, endDate: NSDate, stage: String, youtubeId: String, favorite: Bool = false) {
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
        self.scheduleDayString = scheduleDate.day == 9 ? "Dijous" : scheduleDate.day == 10 ? "Divendres" : "Dissabte"
    }
    
    required convenience public init(coder decoder: NSCoder) {
        self.init(artistId: decoder.decodeIntegerForKey("artistId"),
                  name: decoder.decodeObjectForKey("name") as! String,
                  longDescription: decoder.decodeObjectForKey("longDescription") as! String,
                  artistURL: decoder.decodeObjectForKey("artistURL") as! NSURL,
                  imageURL: decoder.decodeObjectForKey("imageURL") as! NSURL,
                  startDate: decoder.decodeObjectForKey("startDate") as! NSDate,
                  endDate: decoder.decodeObjectForKey("endDate") as! NSDate,
                  stage: decoder.decodeObjectForKey("stage") as! String,
                  youtubeId: decoder.decodeObjectForKey("youtubeId") as! String,
                  favorite: decoder.decodeBoolForKey("favorite"))
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(artistId, forKey: "artistId")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(longDescription, forKey: "longDescription")
        coder.encodeObject(stage, forKey: "stage")
        coder.encodeObject(youtubeId, forKey: "youtubeId")
        coder.encodeObject(artistURL, forKey: "artistURL")
        coder.encodeObject(imageURL, forKey: "imageURL")
        coder.encodeObject(startDate, forKey: "startDate")
        coder.encodeObject(endDate, forKey: "endDate")
        coder.encodeBool(favorite, forKey: "favorite")
    }
    
    override public var description: String {
        return "Artist: \(name), id \(artistId), description\(longDescription), favorited? \(favorite)"
    }
}
