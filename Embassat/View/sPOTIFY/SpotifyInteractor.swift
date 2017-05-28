//
//  SpotifyInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit
import Spotify
import SwiftyJSON

struct SpotifyTrack {
    let name: String
    let artist: String
    let playableURI: String
    let imageURL: URL
}

final class SpotifyInteractor: Interactor {
    
    var modelDidUpdate: (([SpotifyTrack]) -> ())?
    
    fileprivate(set) var model: [SpotifyTrack] = [] {
        didSet {
            modelDidUpdate?(model)
        }
    }
    
    let auth: SPTAuth
    
    init(auth: SPTAuth) {
        self.auth = auth
    }

    func fetchTracks() {
        guard let request = try? SPTRequest.createRequest(
            for: URL(string: "https://api.spotify.com/v1/users/embassat/playlists/7HFjIyFcpxDfl4GMnoms0v/tracks")!,
            withAccessToken: auth.session.accessToken,
            httpMethod: "GET",
            values: [],
            valueBodyIsJSON: false,
            sendDataAsQueryString: true) else { return }
        
        SPTRequest.sharedHandler().perform(request) { [weak self] (error, response, data) in
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let jsonTracks = jsonData?["items"] as? [[String : Any]],
                error == nil else { return }
            
            var tracks: [SpotifyTrack] = []
            
            for (_,subJson):(String, JSON) in JSON(jsonTracks) {
                let name = subJson["track"]["name"].stringValue
                let artist = subJson["track"]["artists"][0]["name"].stringValue
                let images = subJson["track"]["album"]["images"]
                let uri = subJson["track"]["uri"].stringValue
                let imageURL = images[0]["url"].stringValue
                let track = SpotifyTrack(name: name, artist: artist, playableURI: uri, imageURL: URL(string: imageURL)!)
                
                tracks.append(track)
            }
            
            self?.model = tracks
        }
    }
}
