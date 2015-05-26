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
    
    func initialMinute(forIndexPath indexPath : NSIndexPath) -> String {
        let minute = self.artist(forIndexPath: indexPath).startDate.minute
        
        return String(format: "%@%@", minute < 10 ? "0" : "", String(minute))
    }
    
    func initialHour(forIndexPath indexPath : NSIndexPath) -> String {
        let hour = self.artist(forIndexPath: indexPath).startDate.hour
        
        return String(format: "%@%@", hour < 10 ? "0" : "", String(hour))
    }
    
    public func initialTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.initialHour(forIndexPath: indexPath), self.initialMinute(forIndexPath: indexPath))
    }
    
    func finalMinute(forIndexPath indexPath : NSIndexPath) -> String {
        let minute = self.artist(forIndexPath: indexPath).endDate.minute
        
        return String(format: "%@%@", minute < 10 ? "0" : "", String(minute))
    }
    
    func finalHour(forIndexPath indexPath : NSIndexPath) -> String {
        let hour = self.artist(forIndexPath: indexPath).endDate.hour
        
        return String(format: "%@%@", hour < 10 ? "0" : "", String(hour))
    }
    
    public func finalTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.finalHour(forIndexPath: indexPath), self.finalMinute(forIndexPath: indexPath))
    }
    
    public func favoritedStatus(forIndexPath indexPath : NSIndexPath) -> Bool {
        return self.artist(forIndexPath: indexPath).favorite
    }
    
    public func artistViewModel(forIndexPath indexPath : NSIndexPath) -> CADEMArtistDetailViewModel {
        return CADEMArtistDetailViewModel(model: model[dayIndex], currentIndex: indexPath.item)
    }
    
    public func color(forIndexPath indexPath : NSIndexPath) -> UIColor {
        let colors: Dictionary<String, UIColor> =
            ["Amfiteatre Yeearphone" : UIColor.em_stageRedColor(),
             "Escenari Gran" : UIColor.em_stageYellowColor(),
             "Mirador" : UIColor.em_stageBlueColor()]
        
        return colors[self.stageName(forIndexPath: indexPath)]!
    }
    
    public func backgroundColor(forIndexPath indexPath : NSIndexPath) -> UIColor {
        let artist: CADEMArtist = self.artist(forIndexPath: indexPath)
        let now: NSDate = NSDate()
        
        return now.isLaterThanDate(artist.startDate) && now.isEarlierThanDate(artist.endDate) ? UIColor.em_backgroundColor() : UIColor.em_backgroundDeselectedColor()
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
