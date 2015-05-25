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
    let parser: CADEMArtistParser = CADEMArtistParser()
    let notificationService: CADEMNotificationService = CADEMNotificationService()
    
    public func artists() -> RACSignal
    {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            var cachedArtists: Array<CADEMArtist> = []
            
            if let cached = self.store.object(forKey: CADEMArtistService.kArtistsStoreKey) as? Array<CADEMArtist> {
                cachedArtists = cached
                subscriber?.sendNext(cachedArtists)
            }
            
            Manager.sharedInstance.request(.GET, CADEMArtistService.kArtistsEndpoint)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        subscriber?.sendError(error)
                    }
                    else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let artists = self.parser.parseArtists(fromJson: json!, cached: cachedArtists)

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
    
    public func cachedArtists() -> RACSignal
    {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            if let cachedArtists: Array<CADEMArtist> = self.store.object(forKey: CADEMArtistService.kArtistsStoreKey) as? Array<CADEMArtist> {
                subscriber?.sendNext(cachedArtists)
                subscriber?.sendCompleted()
            } else {
                subscriber?.sendCompleted()
            }
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
    
    public func toggleFavorite(forArtist artist: CADEMArtist) -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            if var cachedArtists: Array<CADEMArtist> = self.store.object(forKey: CADEMArtistService.kArtistsStoreKey) as? Array<CADEMArtist> {
                
                var index = NSNotFound
                
                for var i = 0; i < cachedArtists.count; i++
                {
                    if cachedArtists[i].artistId == artist.artistId {
                        index = i
                        break
                    }
                }
                
                if index != NSNotFound {
                    cachedArtists[index].favorite = !cachedArtists[index].favorite
                    self.store.store(cachedArtists, forKey: CADEMArtistService.kArtistsStoreKey)
                    subscriber?.sendNext(cachedArtists[index].favorite)
                    subscriber?.sendCompleted()
                    self.notificationService.toggleLocalNotification(forArtist: artist, favorited: cachedArtists[index].favorite)
                } else {
                    subscriber?.sendError(nil)
                }
            }
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
}
