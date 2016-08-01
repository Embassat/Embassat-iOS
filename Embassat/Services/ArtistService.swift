//
//  ArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistService {
    
    static let kArtistsEndpoint = "https://scorching-torch-2707.firebaseio.com/artists.json"
    static private let kArtistsStoreKey = "/artists.db_2"
    
    private let store: ArtistStore = ArtistStore()
    private let parser: ArtistParser = ArtistParser()
    private let notificationService: NotificationService = NotificationService()
    private var lastTask: NSURLSessionDataTask?
    
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
    
    func toggleFavorite(forArtist artist: CADEMArtist, completion: (CADEMArtist) -> ()) {
        if var cachedArtists = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            
            var index = NSNotFound
            
            for (i, cachedArtist) in cachedArtists.enumerate() {
                if cachedArtist.artistId == artist.artistId {
                    index = i
                    break
                }
            }
            
            if index != NSNotFound {
                cachedArtists[index].favorite = !cachedArtists[index].favorite
                store.store(cachedArtists, forKey: ArtistService.kArtistsStoreKey)
                completion(cachedArtists[index])
                notificationService.toggleLocalNotification(forArtist: artist, favorited: cachedArtists[index].favorite)
            }
        }
    }
}
