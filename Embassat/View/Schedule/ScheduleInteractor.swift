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
    
    var title: String {
        switch self {
        case .first:
            return "Divendres"
        case .second:
            return "Dissabte"
        }
    }
    
    var date: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 6
        let calendar = Calendar.current
        
        switch self {
        case .first:
            dateComponents.day = 9
        case .second:
            dateComponents.day = 10
        }
        
        return calendar.date(from: dateComponents)!
    }
}

final class ScheduleInteractor: Interactor {
    
    var modelDidUpdate: (([CADEMArtist]) -> ())?
    
    fileprivate(set) var model: [CADEMArtist] = [] {
        didSet {
            modelDidUpdate?(model)
        }
    }
    
    fileprivate let service: ArtistService
    let day: ScheduleInteractorDay
    
    init(service: ArtistService = ArtistService(), day: ScheduleInteractorDay) {
        self.service = service
        self.day = day
    }
    
    func fetchArtists() {
        service.persistedArtists { [weak self] (artists) in
            self?.updateArtists(withArtists: artists)
        }
        
        service.artists { [weak self] (artists, error) in
            guard let artists = artists, error == nil else { return }
            self?.updateArtists(withArtists: artists)
        }
    }
    
    fileprivate func updateArtists(withArtists artists: [CADEMArtist]) {
        model = artists
            .filter { $0.scheduleDate.day == day.date.day }
            .sorted { $0.startDate.isEarlierThan($1.startDate) }
    }
}
