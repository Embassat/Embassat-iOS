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
    let date: NSDate
    var favorite: Bool
    
    init(artistId: Int, name: String, longDescription: String, artistURL: NSURL, imageURL: NSURL, date: NSDate, stage: String, favorite: Bool = false) {
        self.artistId = artistId
        self.name = name
        self.longDescription = longDescription
        self.artistURL = artistURL
        self.imageURL = imageURL
        self.date = date
        self.stage = stage
        self.favorite = favorite
    }
    
    required convenience public init(coder decoder: NSCoder) {
        self.init(artistId: decoder.decodeIntegerForKey("artistId"),
                  name: decoder.decodeObjectForKey("name") as! String,
                  longDescription: decoder.decodeObjectForKey("longDescription") as! String,
                  artistURL: decoder.decodeObjectForKey("artistURL") as! NSURL,
                  imageURL: decoder.decodeObjectForKey("imageURL") as! NSURL,
                  date: decoder.decodeObjectForKey("date") as! NSDate,
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
        coder.encodeObject(date, forKey: "date")
        coder.encodeBool(favorite, forKey: "favorite")
    }
    
    override public var description: String {
        return "Artist: \(name), favorited? \(favorite)"
    }
}
