//
//  ScheduleViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class ScheduleViewModel: ViewModelCollectionDelegate, CoordinatedViewModel {
    
    let interactor: ScheduleInteractor
    let coordinator: ScheduleCoordinator
    let model: [CADEMArtist]
    let dateFormatter: DateFormatter
    
    var dayIndex: Int {
        set {
            interactor.day = ScheduleInteractorDay(rawValue: newValue)!
        }
        
        get {
            return interactor.day.rawValue
        }
    }
    
    required init(interactor: ScheduleInteractor, coordinator: ScheduleCoordinator) {
        self.model = interactor.model
        self.interactor = interactor
        self.coordinator = coordinator
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func numberOfItemsInSection(_ section : Int) -> Int {
        return model.count
    }
    
    func shouldRefreshModel() {
        interactor.fetchCachedArtists()
    }
    
    func artistName(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).name
    }
    
    func stageName(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).stage
    }
    
    func favoritedStatus(forIndexPath indexPath : IndexPath) -> Bool {
        return artist(forIndexPath: indexPath).favorite
    }
    
    func startTimeString(forIndexPath indexPath : IndexPath) -> String {
        return String(format: "%@:%@", startHour(forIndexPath: indexPath), startMinute(forIndexPath: indexPath))
    }
    
    func endTimeString(forIndexPath indexPath : IndexPath) -> String {
        return String(format: "%@:%@", endHour(forIndexPath: indexPath), endMinute(forIndexPath: indexPath))
    }
    
    func backgroundColor(forIndexPath indexPath : IndexPath) -> UIColor {
        let artist = self.artist(forIndexPath: indexPath)
        let now: Date = Date()
        
        return now.isLaterThan(artist.startDate) && now.isEarlierThan(artist.endDate) ? .primary : .secondary
    }
    
    func didSelect(at index: Int) {
        coordinator.presentArtistDetail(interactor.model, currentIndex: index)
    }
    
    fileprivate func startMinute(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).startDate.minuteString
    }
    
    fileprivate func startHour(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).startDate.hourString
    }
    
    fileprivate func endMinute(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).endDate.minuteString
    }
    
    fileprivate func endHour(forIndexPath indexPath : IndexPath) -> String {
        return artist(forIndexPath: indexPath).endDate.hourString
    }
    
    fileprivate func artist(forIndexPath indexPath: IndexPath) -> CADEMArtist {
        return model[indexPath.item]
    }
}
