//
//  ArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Firebase

public class ArtistService: NSObject {
    
    static let kArtistsStoreKey : String = "/artists.db"
    
    let store: ArtistStore = ArtistStore()
    let parser: ArtistParser = ArtistParser()
    let notificationService: NotificationService = NotificationService()
    
    public func artists() -> RACSignal
    {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            var cachedArtists: [CADEMArtist] = []
            
            if let cached = self.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
                cachedArtists = cached
                subscriber?.sendNext(cachedArtists)
            }
            
            let fireBaseRoot = Firebase(url: "https://scorching-torch-2707.firebaseio.com/artists")
            fireBaseRoot.observeSingleEventOfType(FEventType.Value, withBlock: { [weak self] snapshot in
                guard let weakSelf = self else { return }
                
                if snapshot.exists() {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let artists = weakSelf.parser.parseArtists(fromJson: snapshot.value, cached: cachedArtists)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            subscriber?.sendNext(artists)
                            subscriber?.sendCompleted()
                        }
                        
                        weakSelf.notificationService.updateLocalNotifications(forArtists: artists)
                        weakSelf.store.store(artists, forKey: ArtistService.kArtistsStoreKey)
                    }
                } else {
                    subscriber?.sendError(nil)
                }
            })
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
    
    public func cachedArtists() -> RACSignal
    {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            if let cachedArtists = self.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
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
            if var cachedArtists = self.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
                
                var index = NSNotFound
                
                for (i, cachedArtist) in cachedArtists.enumerate() {
                    if cachedArtist.artistId == artist.artistId {
                        index = i
                        break
                    }
                }
                
                if index != NSNotFound {
                    cachedArtists[index].favorite = !cachedArtists[index].favorite
                    self.store.store(cachedArtists, forKey: ArtistService.kArtistsStoreKey)
                    subscriber?.sendNext(cachedArtists[index])
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
