//
//  CADEMArtistSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistSwift : NSObject {
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
    
    override public var description: String {
        return "Artist: \(name)"
    }
}
