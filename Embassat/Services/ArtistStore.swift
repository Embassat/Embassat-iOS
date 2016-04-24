//
//  ArtistStore.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

struct ArtistStore {
    
    let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]

    func object(forKey key: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath.stringByAppendingString(key))
    }
    
    func store(object: AnyObject, forKey key: String) {
        NSKeyedArchiver.archiveRootObject(object, toFile: documentsPath.stringByAppendingString(key))
    }
}
