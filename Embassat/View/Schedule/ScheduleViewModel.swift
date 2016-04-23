//
//  ScheduleViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ScheduleViewModel: NSObject, ViewModelCollectionDelegate {
    
    var model: [[CADEMArtist]] = [[], [], []]
    var dayIndex: Int = 0 {
        didSet {
            if dayIndex > 2 {
                dayIndex = 2
            }
            
            if dayIndex < 0 {
                dayIndex = 0
            }
        }
    }
    let service: ArtistService = ArtistService()
    let activeSubject: RACSubject
    let dateFormatter: NSDateFormatter
    
    override init() {
        activeSubject = RACSubject()
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        super.init()
        
        service.artists().map
            { self.dayMapping($0)
            }.subscribeNext(
                { [unowned self] (artists: AnyObject!) -> Void in
                    self.model = artists as! [[CADEMArtist]]
                    self.activeSubject.sendNext(true)
                }, error:
                { [unowned self] (error: NSError!) -> Void in
                    self.activeSubject.sendError(error)
                })
    }
    
    func dayMapping (artists: AnyObject!) -> AnyObject! {
        let artistsArray = artists as! [CADEMArtist]
        
        return [self.filteredArray(artistsArray, withDateString: "2015-06-11"),
                self.filteredArray(artistsArray, withDateString: "2015-06-12"),
                self.filteredArray(artistsArray, withDateString: "2015-06-13")]
    }
    
    func shouldRefreshModel() {
        service.cachedArtists().map
            { self.dayMapping($0)
            }.subscribeNext
            { [unowned self] (artists: AnyObject!) -> Void in
                self.model = artists as! [[CADEMArtist]]
        }
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return model[dayIndex].count
    }
    
    func artistName(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).name
    }
    
    func stageName(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).stage
    }
    
    func startMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).startDate.minuteString
    }
    
    func startHour(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).startDate.hourString
    }
    
    func startTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.startHour(forIndexPath: indexPath), self.startMinute(forIndexPath: indexPath))
    }
    
    func endMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).endDate.minuteString
    }
    
    func endHour(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).endDate.hourString
    }
    
    func endTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.endHour(forIndexPath: indexPath), self.endMinute(forIndexPath: indexPath))
    }
    
    func favoritedStatus(forIndexPath indexPath : NSIndexPath) -> Bool {
        return self.artist(forIndexPath: indexPath).favorite
    }
    
    func artistViewModel(forIndexPath indexPath : NSIndexPath) -> ArtistDetailViewModel {
        return ArtistDetailViewModel(model: model[dayIndex], currentIndex: indexPath.item)
    }
    
    func backgroundColor(forIndexPath indexPath : NSIndexPath) -> UIColor {
        let artist: CADEMArtist = self.artist(forIndexPath: indexPath)
        let now: NSDate = NSDate()
        
        return now.isLaterThan(artist.startDate) && now.isEarlierThan(artist.endDate) ? UIColor.emScheduleBackgroundSelectedColor() : UIColor.emScheduleBackgroundDeselectedColor()
    }
    
    func filteredArray(fromArray: [CADEMArtist], withDateString: String) -> [CADEMArtist] {
        return fromArray.filter({ (artist: CADEMArtist) -> Bool in
            return self.dateFormatter.stringFromDate(artist.scheduleDate) == withDateString
        }).sort(sortingByDate)
    }
    
    func sortingByDate(forFirstArtist artist1: CADEMArtist, andSecondArtist artist2: CADEMArtist) -> Bool {
        return artist1.startDate.isEarlierThan(artist2.startDate)
    }
    
    func artist(forIndexPath indexPath: NSIndexPath) -> CADEMArtist {
        return model[dayIndex][indexPath.item]
    }
}
