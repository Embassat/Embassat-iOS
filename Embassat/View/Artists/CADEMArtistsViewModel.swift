//
//  CADEMArtistsViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMArtistsViewModel: NSObject, CADEMViewModelCollectionDelegateSwift {
    
    var model: Array<CADEMArtistSwift> = []
    public let activeSubject: RACSubject
    
    override init() {
        activeSubject = RACSubject()
        
        super.init()
        
        self.artists().map
            { (artists: AnyObject!) -> AnyObject! in
                let artistsArray = artists as! Array<CADEMArtistSwift>
                return sorted(artistsArray) { (artist1, artist2) in
                    return artist1.name < artist2.name
                }
            }.subscribeNext(
                { [unowned self] (artists: AnyObject!) -> Void in
                    self.model = artists as! Array<CADEMArtistSwift>
                    self.activeSubject.sendNext(true)
            }, error:
                { [unowned self] (error: NSError!) -> Void in
                    self.activeSubject.sendError(error)
            })
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return self.model.count
    }
    
    public func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.model[indexPath.row].name.uppercaseString
    }
    
    public func artistViewModel(forIndexPath indexPath: NSIndexPath) -> CADEMArtistDetailViewModel {
        return CADEMArtistDetailViewModel(model: self.model[indexPath.row])
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
