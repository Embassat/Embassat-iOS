//
//  CADArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADArtistService: NSObject {
    
    static let kArtistsEndpoint : String = "http://www.embassat.com/wp-json/posts?type=portfolio&count=100"
    
    public func artists (failure : (NSError) -> (), success : (Array<CADEMArtistSwift>) -> ())
    {
        Manager.sharedInstance.request(.GET, CADArtistService.kArtistsEndpoint)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    failure(error!)
                }
                else {
                    let artists = CADArtistParser().parseArtists(fromJson: json!)
                    success(artists)
                }
        }
    }
}
