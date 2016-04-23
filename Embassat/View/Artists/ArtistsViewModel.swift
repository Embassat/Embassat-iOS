//
//  ArtistsViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ArtistsViewModel: NSObject, ViewModelCollectionDelegate {
    
    var model: [CADEMArtist] = []
    let service: ArtistService = ArtistService()
    let activeSubject: RACSubject
    
    override init() {
        activeSubject = RACSubject()
        
        super.init()
        
        service.artists().map
            { artists in
                guard let artists = artists as? [CADEMArtist] else { return [] }
                
                return artists.sort({ (artist1, artist2) -> Bool in
                    artist1.name < artist2.name
                })
            }.subscribeNext(
                { [weak self] artists in
                    guard let weakSelf = self,
                              artists = artists as? [CADEMArtist] else { return }
                    
                    weakSelf.model = artists
                    weakSelf.activeSubject.sendNext(true)
            }, error:
                { [weak self] (error: NSError!) -> Void in
                    guard let weakSelf = self else { return }
                    
                    weakSelf.activeSubject.sendError(error)
            })
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return model.count
    }
    
    func shouldRefreshModel() {
        service.cachedArtists().map{ artists in
            guard let artists = artists as? [CADEMArtist] else { return [] }

            return artists.sort({ (artist1, artist2) -> Bool in
                artist1.name < artist2.name
            })
        }.subscribeNext { [weak self] artists in
            guard let weakSelf = self ,
                      artists = artists as? [CADEMArtist] else { return }
            
            weakSelf.model = artists
        }
    }
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.model[indexPath.row].name.uppercaseString
    }
    
    func artistViewModel(forIndexPath indexPath: NSIndexPath) -> ArtistDetailViewModel {
        return ArtistDetailViewModel(model: model, currentIndex: indexPath.item)
    }
}
