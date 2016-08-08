//
//  ArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class ArtistDetailViewModel<U: ArtistDetailCoordinatorProtocol, T: ArtistDetailInteractorProtocol where T.ModelType == CADEMArtist>: CoordinatedViewModel {
    
    private var model: CADEMArtist {
        get {
            return interactor.model
        }
    }
    
    let interactor: T
    let coordinator: U

    /** The artist name string. */
    var artistName: String {
        return model.name
    }
    
    /** The artist description string, embedded in escaped "". 
     
     
     For instance, if the description of the artist is `foo`, this string should be -> \"foo\"
     */
    var artistDescription: String {
        return "\"\(model.longDescription)\""
    }
    
    /** The artist time string, embedded in escaped "".
     
     For instance, if the start date of the artist is `20:45` this string should be -> \"20:45\"
     */
    var artistStartTimeString: String {
        return "\"\(model.startDate.hourString):\(model.startDate.minuteString)\""
    }
    
    /** The artist day string. */
    var artistDay: String {
        return model.scheduleDayString
    }
    
    /** The artist stage string. */
    var artistStage: String {
        return model.stage
    }
    
    /** The artist video id. */
    var artistVideoId: String {
        return model.youtubeId
    }
    
    /** Whether the artist is favorited by the user or not. */
    var artistIsFavorite: Bool {
        return model.favorite
    }
    
    /** The artist image URL. */
    var artistImageURL: NSURL {
        return model.imageURL
    }
    
    /**
     Initializes a new ArtistDetailViewModel.
     
     - parameter interactor: An interactor conforming to ArtistDetailInteractorProtocol.
     - parameter coordinator: A coordinator conforming to ArtistDetailCoordinatorProtocol.
     */
    required init(interactor: T, coordinator: U) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    /** The index of the currently displayed artist. Setting this property will update all properties in this view model */
    var currentIndex: Int {
        get {
            return interactor.currentIndex()
        }
        set {
            interactor.updateModel(withNexIndex: currentIndex)
        }
    }
    
    /** Shares the action using the concrete ArtistDetailCoordinatorProtocol share action */
    func shareAction() {
        coordinator.showShareAction(withURL: model.artistURL, title: String(format: "%@ @ Embassa't 2016", artistName))
    }
    
    /** Toggles the favorite state of the currently displayed artist. */
    func toggleFavorite() {
        interactor.toggleFavorite()
    }
}
