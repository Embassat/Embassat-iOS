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
    let imageURL: NSURL
    
    init(name: String, longDescription: String, imageURL: NSURL) {
        self.name = name
        self.longDescription = longDescription
        self.imageURL = imageURL
    }
    
    override public var description: String {
        return "Artist: \(name)"
    }
}
