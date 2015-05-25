//
//  CADEMScheduleViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMScheduleViewModel: NSObject, CADEMViewModelCollectionDelegateSwift {
    
    var model: Array<Array<CADEMArtistSwift>> = [[], [], []]
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
    
    override init() {
        activeSubject = RACSubject()
        
        super.init()
        
        service.artists().map
            { (artists: AnyObject!) -> AnyObject! in
                let artistsArray = artists as! Array<CADEMArtistSwift>
                return [artistsArray, artistsArray, artistsArray]
            }.subscribeNext(
                { [unowned self] (artists: AnyObject!) -> Void in
                    self.model = artists as! Array<Array<CADEMArtistSwift>>
                    self.activeSubject.sendNext(true)
                }, error:
                { [unowned self] (error: NSError!) -> Void in
                    self.activeSubject.sendError(error)
                })
    }
    
    public func shouldRefreshModel() {
        service.cachedArtists().map
            { (artists: AnyObject!) -> AnyObject! in
                let artistsArray = artists as! Array<CADEMArtistSwift>
                return [artistsArray, artistsArray, artistsArray]
            }.subscribeNext
            { [unowned self] (artists: AnyObject!) -> Void in
                self.model = artists as! Array<Array<CADEMArtistSwift>>
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
        return String(self.artist(forIndexPath: indexPath).date.minute)
    }
    
    func initialHour(forIndexPath indexPath : NSIndexPath) -> String {
        return String(self.artist(forIndexPath: indexPath).date.hour)
    }
    
    public func initialTimeString(forIndexPath indexPath : NSIndexPath) -> String {
        return String(format: "%@:%@", self.initialHour(forIndexPath: indexPath), self.initialMinute(forIndexPath: indexPath))
    }
    
    func finalMinute(forIndexPath indexPath : NSIndexPath) -> String {
        return String(self.artist(forIndexPath: indexPath).date.minute)
    }
    
    func finalHour(forIndexPath indexPath : NSIndexPath) -> String {
        return String(self.artist(forIndexPath: indexPath).date.hour)
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
        let artist: CADEMArtistSwift = self.artist(forIndexPath: indexPath)
        let now: NSDate = NSDate()
        
        return now.isLaterThanDate(artist.date) && now.isEarlierThanDate(artist.date) ? UIColor.em_backgroundColor() : UIColor.em_backgroundDeselectedColor()
    }
    
//    - (NSArray *)filteredArrayFromArray:(NSArray *)array withDateString:(NSString *)dateString
//    {
//    return [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date == %@", dateString]] sortedArrayUsingComparator:^NSComparisonResult(CADEMArtistSwift *artist1, CADEMArtistSwift *artist2) {
//    return [artist1.date isEarlierThanDate:artist2.date];
//    }];
//    }
    
    //- (NSArray *)filteredFixingHoursArrayFromArray:(NSArray *)array
    //{
    //    return [[[array rac_sequence] filter:^BOOL(CADEMArtistSwift *artist) {
    //        return ![[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
    //    }] concat:[[array rac_sequence] filter:^BOOL(CADEMArtistSwift *artist) {
    //        return [[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
    //    }]].array;
    //}
    
    func artist(forIndexPath indexPath: NSIndexPath) -> CADEMArtistSwift {
        return model[dayIndex][indexPath.item]
    }
}
