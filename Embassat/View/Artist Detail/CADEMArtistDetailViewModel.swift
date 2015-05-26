//
//  CADEMArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import EventKit

public class CADEMArtistDetailViewModel: NSObject {
    
    var model: Array<CADEMArtist>
    let service: CADEMArtistService = CADEMArtistService()
    
    var currentArtist: CADEMArtist
    var artistName: String = ""
    var artistDescription: String = ""
    var artistStartTimeString: String = ""
    var artistDay: String = ""
    var artistStage: String = ""
    var artistIsFavorite: Bool = false
    var artistImageURL: NSURL? = nil
    
    public var currentIndex: Int = 0 {
        didSet {
            if currentIndex > count(model) - 1 {
               currentIndex = count(model) - 1
            }
            
            if currentIndex < 0 {
                currentIndex = 0
            }
            
            currentArtist = model[currentIndex]
            self.updateCurrentArtistData()
        }
    }
    
    init(model: Array<CADEMArtist>, currentIndex: Int) {
        self.model = model
        self.currentIndex = currentIndex
        
        currentArtist = model[currentIndex]
        
        super.init()
        
        self.updateCurrentArtistData()
    }
    
    public func shareAction(forViewController viewController: UIViewController) {
        let item: AnyObject! = SHKItem.URL(currentArtist.artistURL, title: String(format: "%@ @ Embassa't", self.artistName), contentType: SHKURLContentTypeUndefined)
        let actionSheet = SHKActionSheet(forItem: item as! SHKItem)
        SHK.setRootViewController(viewController)
        
        actionSheet.showFromToolbar(viewController.navigationController?.toolbar)
    }
    
    public func toggleFavorite(completion: () -> ()) {
        service.toggleFavorite(forArtist: currentArtist).subscribeNext {
            [unowned self] (updatedArtist: AnyObject!) -> Void in
            self.model[self.currentIndex] = updatedArtist as! CADEMArtist
            completion()
        }
    }
    
    func updateCurrentArtistData() {
        artistName = currentArtist.name
        artistDescription = currentArtist.longDescription
        artistStage = currentArtist.stage
        artistImageURL = currentArtist.imageURL
        artistStartTimeString = String(format: "%@:%@", String(currentArtist.startDate.hourString), String(currentArtist.startDate.minuteString))
        artistIsFavorite = currentArtist.favorite
        artistDay = currentArtist.scheduleDayString
    }
   
}
