//
//  ArtistService.swift
//  Embassa't
//
//  Created by Joan Romano on 11/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

protocol ArtistServiceProtocol {
    func artists(_ completion: @escaping ([CADEMArtist]?, NSError?) -> ())
    func persistedArtists(_ completion: ([CADEMArtist]) -> ())
    func toggleFavorite(forArtist artist: CADEMArtist, completion: (CADEMArtist) -> ())
}

class ArtistService: ArtistServiceProtocol {
    
    static let kArtistsEndpoint = "https://scorching-torch-2707.firebaseio.com/artists.json"
    static let kArtistsStoreKey = "/artists.db_2"
    
    let store: ArtistStore = ArtistStore()
    let parser: ArtistParser = ArtistParser()
    let notificationService: NotificationService = NotificationService()
    
    fileprivate var lastTask: URLSessionDataTask?
    
    /**
     Retrieves the artists from the network, also persisting them in disk.
     
     - parameter completion: A completion which will get called with an optional array of artists and an optional error, if any. Note that both can be nil if there is no error but the response's status code is not 200.
     */
    func artists(_ completion: @escaping ([CADEMArtist]?, NSError?) -> ()) {
        var cachedArtists: [CADEMArtist] = []
        let url = URL(string: ArtistService.kArtistsEndpoint)!
        
        if let cached = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            cachedArtists = cached
        }
        
        lastTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            
            if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), error == nil {
                
                DispatchQueue.global().async {
                    let artists = strongSelf.parser.parseArtists(fromJson: json as AnyObject, cached: cachedArtists)
                    strongSelf.notificationService.updateLocalNotifications(forArtists: artists)
                    strongSelf.store.store(artists as AnyObject, forKey: ArtistService.kArtistsStoreKey)
                    
                    DispatchQueue.main.async {
                        completion(artists, nil)
                    }
                }
            } else if let error = error {
                completion(nil, error as NSError?)
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, nil)
            }
        }) 
        
        lastTask?.resume()
    }
    
    /**
     Retrieves the persisted artists from disk.
     
     - parameter completion: A completion which will get called with an array of the persisted artists. This can be an empty array if no persisted artists.
     */
    func persistedArtists(_ completion: ([CADEMArtist]) -> ()) {
        if let cachedArtists = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            completion(cachedArtists)
        } else {
            completion([])
        }
    }
    
    /**
     Toggles and persists the favorite state of an already artist. Will do nothing if the artist is not present in the currently peristed artists.
     
     - parameter artist: The artist to toggle the favorite state from.
     - parameter completion: A completion which will get called with the updated artist.
     */
    func toggleFavorite(forArtist artist: CADEMArtist, completion: (CADEMArtist) -> ()) {
        if var cachedArtists = store.object(forKey: ArtistService.kArtistsStoreKey) as? [CADEMArtist] {
            if let index = cachedArtists.index(where: { $0.artistId == artist.artistId }) {
                cachedArtists[index].favorite = !cachedArtists[index].favorite
                store.store(cachedArtists as AnyObject, forKey: ArtistService.kArtistsStoreKey)
                completion(cachedArtists[index])
                notificationService.toggleLocalNotification(forArtist: artist, favorited: cachedArtists[index].favorite)
            }
        }
    }
}
