//
//  CADEMScheduleViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMScheduleViewModel: NSObject, CADEMViewModelCollectionDelegate {
    
    var model: Array<Array<CADEMArtist>> = [[], [], []]
    public var dayIndex: Int = 0 {
        didSet {
            if dayIndex > 2 {
                dayIndex = 2
            }
            
            if dayIndex < 0 {
                dayIndex = 0
            }
        }
    }
    public let service: CADEMArtistService = CADEMArtistService()
    public let activeSubject: RACSubject
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
                    self.model = artists as! Array<Array<CADEMArtist>>
                    self.activeSubject.sendNext(true)
                }, error:
                { [unowned self] (error: NSError!) -> Void in
                    self.activeSubject.sendError(error)
                })
    }
    
    func dayMapping (artists: AnyObject!) -> AnyObject! {
        let artistsArray = artists as! Array<CADEMArtist>
        
        return [self.filteredArray(artistsArray, withDateString: "2015-06-11"),
                self.filteredArray(artistsArray, withDateString: "2015-06-12"),
                self.filteredArray(artistsArray, withDateString: "2015-06-13")]
    }
    
    public func shouldRefreshModel() {
        service.cachedArtists().map
            { self.dayMapping($0)
            }.subscribeNext
            { [unowned self] (artists: AnyObject!) -> Void in
                self.model = artists as! Array<Array<CADEMArtist>>
        }
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return model[dayIndex].count
    }
    
    public func artistName(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).name
    }
    
    public func stageName(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).stage
    }
    
    func startMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).startDate.minuteString
    }
    
    func startHour(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).startDate.hourString
    }
    
    public func startTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.startHour(forIndexPath: indexPath), self.startMinute(forIndexPath: indexPath))
    }
    
    func endMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).endDate.minuteString
    }
    
    func endHour(forIndexPath indexPath : NSIndexPath) -> String {
        return self.artist(forIndexPath: indexPath).endDate.hourString
    }
    
    public func endTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.endHour(forIndexPath: indexPath), self.endMinute(forIndexPath: indexPath))
    }
    
    public func favoritedStatus(forIndexPath indexPath : NSIndexPath) -> Bool {
        return self.artist(forIndexPath: indexPath).favorite
    }
    
    public func artistViewModel(forIndexPath indexPath : NSIndexPath) -> CADEMArtistDetailViewModel {
        return CADEMArtistDetailViewModel(model: model[dayIndex], currentIndex: indexPath.item)
    }
    
    public func backgroundColor(forIndexPath indexPath : NSIndexPath) -> UIColor {
        let artist: CADEMArtist = self.artist(forIndexPath: indexPath)
        let now: NSDate = NSDate()
        
        return now.isLaterThanDate(artist.startDate) && now.isEarlierThanDate(artist.endDate) ? UIColor.em_backgroundDeselectedColor() : UIColor.em_backgroundColor()
    }
    
    func filteredArray(fromArray: Array<CADEMArtist>, withDateString: String) -> Array<CADEMArtist> {
        return sorted(fromArray.filter({ (artist: CADEMArtist) -> Bool in
            return self.dateFormatter.stringFromDate(artist.scheduleDate) == withDateString
        }), sortingByDate)
    }
    
    func sortingByDate(forFirstArtist artist1: CADEMArtist, andSecondArtist artist2: CADEMArtist) -> Bool {
        return artist1.startDate.isEarlierThanDate(artist2.startDate)
    }
    
    func artist(forIndexPath indexPath: NSIndexPath) -> CADEMArtist {
        return model[dayIndex][indexPath.item]
    }
}
