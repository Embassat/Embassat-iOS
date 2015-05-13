//
//  CADEMArtistSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistSwift : Printable {
    let name: String
    let largeDescription: String
    let imageURLString: String
    
    init(name: String, largeDescription: String, imageURLString: String) {
        self.name = name
        self.largeDescription = largeDescription
        self.imageURLString = imageURLString
    }
    
    public var description: String {
        return "Artist: \(name)"
    }
}
