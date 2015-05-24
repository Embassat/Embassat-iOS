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
    
    public func artists() -> RACSignal
    {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            if let cachedArtists: Array<CADEMArtistSwift> = self.store.object(forKey: CADEMArtistService.kArtistsStoreKey) as? Array<CADEMArtistSwift> {
                subscriber?.sendNext(cachedArtists)
            }
            
            Manager.sharedInstance.request(.GET, CADEMArtistService.kArtistsEndpoint)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        subscriber?.sendError(error)
                    }
                    else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let artists = CADEMArtistParser().parseArtists(fromJson: json!)

                            dispatch_async(dispatch_get_main_queue()) {
                                subscriber?.sendNext(artists)
                                subscriber?.sendCompleted()
                            }
                            
                            self.store.store(artists, forKey: CADEMArtistService.kArtistsStoreKey)
                        }
                    }
            }
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
}
