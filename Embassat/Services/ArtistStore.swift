//
//  ArtistStore.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class ArtistStore: NSObject {
    
    let documentsPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]

    public func object(forKey key: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath.stringByAppendingString(key))
    }
    
    public func store(object: AnyObject, forKey key: String) {
        NSKeyedArchiver.archiveRootObject(object, toFile: documentsPath.stringByAppendingString(key))
    }
}
