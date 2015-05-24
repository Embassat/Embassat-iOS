//
//  CADEMArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistService: NSObject {
    
    static let kArtistsEndpoint : String = "http://www.embassat.com/wp-json/posts?type=portfolio&count=100"
    static let kArtistsStoreKey : String = "/artists.db"
    
    let store: CADEMStore = CADEMStore()
    
    public func artists (failure : (NSError) -> (), success : (Array<CADEMArtistSwift>) -> ())
    {
        if let cachedArtists: Array<CADEMArtistSwift> = store.object(forKey: CADEMArtistService.kArtistsStoreKey) as? Array<CADEMArtistSwift> {
            success(cachedArtists)
        }
        
        Manager.sharedInstance.request(.GET, CADEMArtistService.kArtistsEndpoint)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    failure(error!)
                }
                else {
                    let artists = CADEMArtistParser().parseArtists(fromJson: json!)
                    success(artists)
                    self.store.store(artists, forKey: CADEMArtistService.kArtistsStoreKey)
                }
        }
    }
}
