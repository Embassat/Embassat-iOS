//
//  CADEMArtistsViewModelSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistsViewModelSwift: NSObject, CADEMViewModelCollectionDelegateSwift {
    
    let model: Array<CADEMArtistSwift> = []
    
    override init() {
        super.init()
        
        self.artists().map { (artists: AnyObject!) -> AnyObject! in
            let artistsArray = artists as! Array<CADEMArtistSwift>
            return sorted(artistsArray) { (artist1, artist2) in
                return artist1.name < artist2.name
            }
        }
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return self.model.count
    }
    
    public func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.model[indexPath.row].name.uppercaseString
    }
    
    func artists() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber?) -> RACDisposable! in
            
            let service: CADArtistService = CADArtistService()
            service.artists(
                { (error: NSError) -> () in
                    subscriber?.sendError(error)
                }, success: { (artists: Array<CADEMArtistSwift>) -> () in
                    subscriber?.sendNext(artists)
                    subscriber?.sendCompleted()
            })
            
            return nil
        }).replayLazily()
    }
}