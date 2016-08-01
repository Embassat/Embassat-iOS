//
//  ScheduleViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class ScheduleViewModel: ViewModelCollectionDelegate, CoordinatedViewModel {
    
    let interactor: ScheduleInteractor
    let coordinator: ScheduleCoordinator
    let model: [CADEMArtist]
    let dateFormatter: NSDateFormatter
    
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
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return model.count
    }
    
    func shouldRefreshModel() {
        interactor.fetchCachedArtists()
    }
    
    func artistName(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).name
    }
    
    func stageName(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).stage
    }
    
    func favoritedStatus(forIndexPath indexPath : NSIndexPath) -> Bool {
        return artist(forIndexPath: indexPath).favorite
    }
    
    func startTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", startHour(forIndexPath: indexPath), startMinute(forIndexPath: indexPath))
    }
    
    func endTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", endHour(forIndexPath: indexPath), endMinute(forIndexPath: indexPath))
    }
    
    func backgroundColor(forIndexPath indexPath : NSIndexPath) -> UIColor {
        let artist = self.artist(forIndexPath: indexPath)
        let now: NSDate = NSDate()
        
        return now.isLaterThan(artist.startDate) && now.isEarlierThan(artist.endDate) ? UIColor.emScheduleBackgroundSelectedColor() : UIColor.emScheduleBackgroundDeselectedColor()
    }
    
    func didSelect(at index: Int) {
        coordinator.presentArtistDetail(interactor.model, currentIndex: index)
    }
    
    private func startMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).startDate.minuteString
    }
    
    private func startHour(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).startDate.hourString
    }
    
    private func endMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).endDate.minuteString
    }
    
    private func endHour(forIndexPath indexPath : NSIndexPath) -> String {
        return artist(forIndexPath: indexPath).endDate.hourString
    }
    
    private func artist(forIndexPath indexPath: NSIndexPath) -> CADEMArtist {
        return model[indexPath.item]
    }
}
