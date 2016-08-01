//
//  ArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistDetailViewModel: CoordinatedViewModel {
    
    let model: CADEMArtist
    let interactor: ArtistDetailInteractor
    let coordinator: ArtistDetailCoordinator

    var artistName: String {
        return model.name
    }
    
    var artistDescription: String {
        return "\"\(model.longDescription)\""
    }
    
    var artistStartTimeString: String {
        return "\"\(model.startDate.hourString):\(model.startDate.minuteString)\""
    }
    
    var artistDay: String {
        return model.scheduleDayString
    }
    
    var artistStage: String {
        return model.stage
    }
    
    var artistVideoId: String {
        return model.youtubeId
    }
    
    var artistIsFavorite: Bool {
        return model.favorite
    }
    
    var artistImageURL: NSURL {
        return model.imageURL
    }
    
    required init(interactor: ArtistDetailInteractor, coordinator: ArtistDetailCoordinator) {
        self.model = interactor.model
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    init(model: [CADEMArtist], currentIndex: Int) {
        self.interactor = ArtistDetailInteractor(artists: model, index: currentIndex)
        self.coordinator = ArtistDetailCoordinator()
        self.model = self.interactor.model
    }
    
    var currentIndex: Int {
        set {
            interactor.currentIndex = newValue
        }
        
        get {
            return interactor.currentIndex
        }
    }
    
    func shareAction() {
        coordinator.showShareAction(withURL: model.artistURL, title: String(format: "%@ @ Embassa't 2016", artistName))
    }
    
    func toggleFavorite() {
        interactor.toggleFavorite()
    }
   
}
