//
//  ArtistStore.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

struct ArtistStore {
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0]

    func object(forKey key: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: documentsPath + key) as AnyObject?
    }
    
    func store(_ object: AnyObject, forKey key: String) {
        NSKeyedArchiver.archiveRootObject(object, toFile: documentsPath + key)
    }
}
