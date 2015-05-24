//
//  CADEMArtistSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistSwift : NSObject, NSCoding {
    let name: String
    let longDescription: String
    let stage: String
    let artistURL: NSURL
    let imageURL: NSURL
    let date: NSDate
    
    init(name: String, longDescription: String, artistURL: NSURL, imageURL: NSURL, date: NSDate, stage: String) {
        self.name = name
        self.longDescription = longDescription
        self.artistURL = artistURL
        self.imageURL = imageURL
        self.date = date
        self.stage = stage
    }
    
    required convenience public init(coder decoder: NSCoder) {
        self.init(name: decoder.decodeObjectForKey("name") as! String,
                  longDescription: decoder.decodeObjectForKey("longDescription") as! String,
                  artistURL: decoder.decodeObjectForKey("artistURL") as! NSURL,
                  imageURL: decoder.decodeObjectForKey("imageURL") as! NSURL,
                  date: decoder.decodeObjectForKey("date") as! NSDate,
                  stage: decoder.decodeObjectForKey("stage") as! String)
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(longDescription, forKey: "longDescription")
        coder.encodeObject(stage, forKey: "stage")
        coder.encodeObject(artistURL, forKey: "artistURL")
        coder.encodeObject(imageURL, forKey: "imageURL")
        coder.encodeObject(date, forKey: "date")
    }
    
    override public var description: String {
        return "Artist: \(name)"
    }
}
