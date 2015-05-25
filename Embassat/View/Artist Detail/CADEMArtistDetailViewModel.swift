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
    
    let model: Array<CADEMArtist>
    let service: CADEMArtistService = CADEMArtistService()
    
    var currentArtist: CADEMArtist
    var artistName: String = ""
    var artistDescription: String = ""
    var artistStartHour: String = ""
    var artistStartMinute: String = ""
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
        let item: AnyObject! = SHKItem.URL(model[0].artistURL, title: String(format: "%@ @ Embassa't", self.artistName), contentType: SHKURLContentTypeUndefined)
        let actionSheet = SHKActionSheet(forItem: item as! SHKItem)
        SHK.setRootViewController(viewController)
        
        actionSheet.showFromToolbar(viewController.navigationController?.toolbar)
    }
    
    public func toggleFavorite(completion: () -> ()) {
        service.toggleFavorite(forArtist: currentArtist).subscribeNext { (favorited: AnyObject!) -> Void in
            completion()
        }
    }
    
    func updateCurrentArtistData() {
        artistName = currentArtist.name
        artistDescription = currentArtist.longDescription
        artistStage = currentArtist.stage
        artistImageURL = currentArtist.imageURL
        artistStartHour = String(currentArtist.date.hour)
        artistStartMinute = String(currentArtist.date.minute)
        artistIsFavorite = currentArtist.favorite
        artistDay = "Dissabte"
    }
   
}
