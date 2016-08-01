//
//  ArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import EventKit
import ShareKit

class ArtistDetailViewModel {
    
    var model: [CADEMArtist]
    let service: ArtistService = ArtistService()
    
    var currentArtist: CADEMArtist
    var artistName: String = ""
    var artistDescription: String = ""
    var artistStartTimeString: String = ""
    var artistDay: String = ""
    var artistStage: String = ""
    var artistVideoId: String = ""
    var artistIsFavorite: Bool = false
    var artistImageURL: NSURL? = nil
    
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex > model.count - 1 {
               currentIndex = model.count - 1
            }
            
            if currentIndex < 0 {
                currentIndex = 0
            }
            
            currentArtist = model[currentIndex]
            updateCurrentArtistData()
        }
    }
    
    init(model: [CADEMArtist], currentIndex: Int) {
        self.model = model
        self.currentIndex = currentIndex
        self.currentArtist = model[currentIndex]
        updateCurrentArtistData()
    }
    
    func shareAction(forViewController viewController: UIViewController) {
        let item: AnyObject! = SHKItem.URL(currentArtist.artistURL, title: String(format: "%@ @ Embassa't 2016", artistName), contentType: SHKURLContentTypeUndefined)
        
        SHK.setRootViewController(viewController)
        let alertController = SHKAlertController.actionSheetForItem(item as! SHKItem)
        alertController.modalPresentationStyle = .Popover
        let popover = alertController.popoverPresentationController
        popover?.barButtonItem = viewController.toolbarItems?.first
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func toggleFavorite(completion: () -> ()) {
        service.toggleFavorite(forArtist: currentArtist).subscribeNext {
            [weak self] updatedArtist in
            guard let weakSelf = self,
                      updatedArtist = updatedArtist as? CADEMArtist else { return }
            
            weakSelf.model[weakSelf.currentIndex] = updatedArtist
            completion()
        }
    }
    
    func updateCurrentArtistData() {
        artistName = currentArtist.name
        artistDescription = "\"\(currentArtist.longDescription)\""
        artistStage = currentArtist.stage
        artistVideoId = currentArtist.youtubeId
        artistImageURL = currentArtist.imageURL
        artistStartTimeString = String(format: "%@:%@", String(currentArtist.startDate.hourString), String(currentArtist.startDate.minuteString))
        artistIsFavorite = currentArtist.favorite
        artistDay = currentArtist.scheduleDayString
    }
   
}
