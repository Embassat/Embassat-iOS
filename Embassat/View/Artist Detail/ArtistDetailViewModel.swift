//
//  ArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ArtistDetailViewModel<U: ArtistDetailCoordinatorProtocol, T: ArtistDetailInteractorProtocol>: CoordinatedViewModel where T.ModelType == CADEMArtist {
    
    private let model: CADEMArtist
    
    let interactor: T
    let coordinator: U

    /** The artist name string. */
    var artistName: String {
        return model.name
    }
    
    /** The artist description string, embedded in escaped "". 
     
     
     e.g: normal artist description is `foo`, this should return -> \"foo\"
     */
    var artistDescription: String {
        return "\"\(model.longDescription)\""
    }
    
    /** The artist time string E.g: `20:45` */
    var artistStartTimeString: String {
        return "\(model.startDate.hourString):\(model.startDate.minuteString)"
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
    
    /** The artist image URL. */
    var artistImageURL: URL {
        return model.imageURL as URL
    }
    
    /**
     Initializes a new ArtistDetailViewModel.
     
     - parameter interactor: An interactor conforming to ArtistDetailInteractorProtocol.
     - parameter coordinator: A coordinator conforming to ArtistDetailCoordinatorProtocol.
     */
    required init(interactor: T, coordinator: U) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.model = interactor.model
    }
    
    /** Whether the artist video should be shown or not, currently based on the video id. */
    func shouldShowArtistVideo() -> Bool {
        return artistVideoId.characters.count > 0
    }
    
    /** The favorite tint color, currently based on the favorite status of the artist:
     
     Favorite: .yellow
     Non favorite: .secondary
     */
    func favTintColor() -> UIColor {
        return model.favorite ? .orange : .secondary
    }
    
    /** Forwards the next pressed action to the interactor */
    func showNext() {
        interactor.nextArtist()
    }
    
    /** Forwards the previous pressed action to the interactor */
    func showPrevious() {
        interactor.previousArtist()
    }
    
    /** Toggles the favorite state of the currently displayed artist. */
    func toggleFavorite() {
        interactor.toggleFavorite()
    }
    
    /** Shares the action using the concrete ArtistDetailCoordinatorProtocol share action */
    func shareAction() {
        coordinator.showShareAction(withURL: model.artistURL, title: String(format: "%@ @ Embassa't 2016", artistName))
    }
}
