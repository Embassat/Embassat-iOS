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
    let artistURL: NSURL
    let imageURL: NSURL
    let startDate: NSDate
    let endDate: NSDate
    var favorite: Bool
    var scheduleDate: NSDate
    var scheduleDayString: String
    
    init(artistId: Int, name: String, longDescription: String, artistURL: NSURL, imageURL: NSURL, startDate: NSDate, endDate: NSDate, stage: String, favorite: Bool = false) {
        self.artistId = artistId
        self.name = name
        self.longDescription = longDescription
        self.artistURL = artistURL
        self.imageURL = imageURL
        self.startDate = startDate
        self.endDate = endDate
        self.stage = stage
        self.favorite = favorite
        
        scheduleDate = startDate.hour < 10 ? startDate.dateBySubstracting(days: 1) : startDate
        scheduleDayString = scheduleDate.day == 11 ? "Dijous" : scheduleDate.day == 12 ? "Divendres" : "Dissabte"
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
                  favorite: decoder.decodeBoolForKey("favorite"))
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(artistId, forKey: "artistId")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(longDescription, forKey: "longDescription")
        coder.encodeObject(stage, forKey: "stage")
        coder.encodeObject(artistURL, forKey: "artistURL")
        coder.encodeObject(imageURL, forKey: "imageURL")
        coder.encodeObject(startDate, forKey: "startDate")
        coder.encodeObject(endDate, forKey: "endDate")
        coder.encodeBool(favorite, forKey: "favorite")
    }
    
    override public var description: String {
        return "Artist: \(name), favorited? \(favorite)"
    }
}
