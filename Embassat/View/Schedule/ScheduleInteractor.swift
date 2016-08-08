//
//  ScheduleInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

enum ScheduleInteractorDay: Int {
    case First = 0
    case Second = 1
    case Third = 2
    case Fourth = 3
    
    func dateFromDay() -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.year = 2016
        dateComponents.month = 6
        let calendar = NSCalendar.currentCalendar()
        
        switch self {
        case .First:
            dateComponents.day = 9
        case .Second:
            dateComponents.day = 10
        case .Third:
            dateComponents.day = 11
        case .Fourth:
            dateComponents.day = 12
        }
        
        return calendar.dateFromComponents(dateComponents)!
    }
}

class ScheduleInteractor: Interactor {
    
    var updateHandler: (([CADEMArtist]) -> ())?
    
    private(set) var model: [CADEMArtist] = []
    
    private var artists: [CADEMArtist] = []
    private let service = ArtistService()
    
    var day: ScheduleInteractorDay = .First {
        didSet {
            updateArtists(withArtists: artists)
        }
    }
    
    func fetchArtists() {
        service.artists { [weak self] (artists, error) in
            guard let artists = artists where error == nil else { return }
            self?.updateArtists(withArtists: artists)
        }
    }
    
    func fetchCachedArtists() {
        service.cachedArtists { [weak self] (artists) in
            self?.updateArtists(withArtists: artists)
        }
    }
    
    private func updateArtists(withArtists artists: [CADEMArtist]) {
        self.artists = artists
        model = artistsBySelectedDay()
        updateHandler?(model)
    }
    
    private func artistsBySelectedDay() -> [CADEMArtist] {
        return artists.filter { $0.scheduleDate.day == day.dateFromDay().day }.sort { $0.startDate.isEarlierThan($1.startDate) }
    }
}
