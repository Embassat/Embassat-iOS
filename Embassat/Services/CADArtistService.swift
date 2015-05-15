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
                    var artists: [CADEMArtistSwift] = []
                    for (index: String, subJson: JSON) in JSON(json!) {

                        var dateFormatter: NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let artist = CADEMArtistSwift(
                            name: subJson["title"].stringValue,
                            longDescription: subJson["content"].stringValue,
                            imageURL: NSURL(string: subJson["featured_image"]["attachment_meta"]["sizes"]["large"]["url"].stringValue)!,
                            date: dateFormatter.dateFromString(subJson["date"].stringValue)!,
                            stage: subJson["terms"]["portfolio_category"][0]["name"].stringValue
                            )
                        artists.append(artist)
                    }
                    success(artists)
                }
        }
    }
}
