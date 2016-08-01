//
//  ArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ArtistService {
    
    static let kArtistsEndpoint = "https://scorching-torch-2707.firebaseio.com/artists.json"
    static private let kArtistsStoreKey = "/artists.db_2"
    
    private let store: ArtistStore = ArtistStore()
    private let parser: ArtistParser = ArtistParser()
    private let notificationService: NotificationService = NotificationService()
    private var lastTask: NSURLSessionDataTask?
    
    func artists() -> RACSignal
    {
        lastTask?.cancel()
        
        return RACSignal.createSignal { [weak self] subscriber in
            guard let weakSelf = self else { return nil }
            
            var cachedArtists: [CADEMArtist] = []
            let url = NSURL(string: ArtistService.kArtistsEndpoint)!
            
            if let cached = weakSelf.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
                cachedArtists = cached
                subscriber.sendNext(cachedArtists)
            }
            
            weakSelf.lastTask = NSURLSession.sharedSession().dataTaskWithURL(url) { data, _, error in
                
                if let data = data,
                       json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    where error == nil {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        let artists = weakSelf.parser.parseArtists(fromJson: json, cached: cachedArtists)
                        weakSelf.notificationService.updateLocalNotifications(forArtists: artists)
                        weakSelf.store.store(artists, forKey: ArtistService.kArtistsStoreKey)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            subscriber.sendNext(artists)
                            subscriber.sendCompleted()
                        }
                    })
                    
                } else {
                    subscriber?.sendError(error)
                }
            }
            
            weakSelf.lastTask?.resume()
            
            return nil
        }.subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
    
    func artists(completion: ([CADEMArtist]) -> ()) {
        var cachedArtists: [CADEMArtist] = []
        let url = NSURL(string: ArtistService.kArtistsEndpoint)!
        
        if let cached = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            cachedArtists = cached
        }
        
        lastTask = NSURLSession.sharedSession().dataTaskWithURL(url) { [weak self] data, _, error in
            guard let strongSelf = self else { return }
            
            if let data = data,
                   json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                where error == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let artists = strongSelf.parser.parseArtists(fromJson: json, cached: cachedArtists)
                    strongSelf.notificationService.updateLocalNotifications(forArtists: artists)
                    strongSelf.store.store(artists, forKey: ArtistService.kArtistsStoreKey)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(artists)
                    }
                })
            }
        }
        
        lastTask?.resume()
    }
    
    func cachedArtists(completion: ([CADEMArtist]) -> ()) {
        if let cachedArtists = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            completion(cachedArtists)
        }
    }
    
    func cachedArtists() -> RACSignal
    {
        return RACSignal.createSignal { [weak self] subscriber in
            guard let weakSelf = self else { return nil }
            
            if let cachedArtists = weakSelf.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
                subscriber.sendNext(cachedArtists)
                subscriber.sendCompleted()
            } else {
                subscriber.sendCompleted()
            }
            
            return nil
        }.subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
    
    func toggleFavorite(forArtist artist: CADEMArtist) -> RACSignal {
        return RACSignal.createSignal { [weak self] subscriber in
            guard let weakSelf = self else { return nil }
            
            if var cachedArtists = weakSelf.store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
                
                var index = NSNotFound
                
                for (i, cachedArtist) in cachedArtists.enumerate() {
                    if cachedArtist.artistId == artist.artistId {
                        index = i
                        break
                    }
                }
                
                if index != NSNotFound {
                    cachedArtists[index].favorite = !cachedArtists[index].favorite
                    weakSelf.store.store(cachedArtists, forKey: ArtistService.kArtistsStoreKey)
                    subscriber.sendNext(cachedArtists[index])
                    subscriber.sendCompleted()
                    weakSelf.notificationService.toggleLocalNotification(forArtist: artist, favorited: cachedArtists[index].favorite)
                } else {
                    subscriber.sendError(nil)
                }
            } else {
                subscriber.sendCompleted()
            }
            
            return nil
        }.subscribeOn(RACScheduler(priority: RACSchedulerPriorityDefault)).deliverOn(RACScheduler.mainThreadScheduler())
    }
}
