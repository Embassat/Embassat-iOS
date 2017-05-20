//
//  ScheduleInteractor.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

enum ScheduleInteractorDay: Int {
    case first = 0
    case second = 1
    case third = 2
    case fourth = 3
    
    func dateFromDay() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2016
        dateComponents.month = 6
        let calendar = Calendar.current
        
        switch self {
        case .first:
            dateComponents.day = 9
        case .second:
            dateComponents.day = 10
        case .third:
            dateComponents.day = 11
        case .fourth:
            dateComponents.day = 12
        }
        
        return calendar.date(from: dateComponents)!
    }
}

class ScheduleInteractor: Interactor {
    
    var updateHandler: (([CADEMArtist]) -> ())?
    
    fileprivate(set) var model: [CADEMArtist] = []
    
    fileprivate var artists: [CADEMArtist] = []
    fileprivate let service = ArtistService()
    
    var day: ScheduleInteractorDay = .first {
        didSet {
            updateArtists(withArtists: artists)
        }
    }
    
    func fetchArtists() {
        service.artists { [weak self] (artists, error) in
            guard let artists = artists, error == nil else { return }
            self?.updateArtists(withArtists: artists)
        }
    }
    
    func fetchCachedArtists() {
        service.persistedArtists { [weak self] (artists) in
            self?.updateArtists(withArtists: artists)
        }
    }
    
    fileprivate func updateArtists(withArtists artists: [CADEMArtist]) {
        self.artists = artists
        model = artistsBySelectedDay()
        updateHandler?(model)
    }
    
    fileprivate func artistsBySelectedDay() -> [CADEMArtist] {
        return artists.filter { $0.scheduleDate.day == day.dateFromDay().day }.sorted { $0.startDate.isEarlierThan($1.startDate) }
    }
}
