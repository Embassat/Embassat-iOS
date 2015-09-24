//
//  NSDate+EMAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import Foundation

extension NSDate {
    
    private static let componentFlags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfMonth, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal]
    
    private static var token: dispatch_once_t = 0
    private static var sharedCalendar: NSCalendar?
    
    class func currentCalendar() -> NSCalendar {
        dispatch_once(&token) { () -> Void in
            sharedCalendar = NSCalendar.autoupdatingCurrentCalendar()
        }
        
        return sharedCalendar ?? NSCalendar.currentCalendar()
    }
    
    var day: Int {
        let components = NSDate.currentCalendar().components(NSDate.componentFlags, fromDate: self)
        return components.day
    }
    
    var hour: Int {
        let components = NSDate.currentCalendar().components(NSDate.componentFlags, fromDate: self)
        return components.hour
    }
    
    var minute: Int {
        let components = NSDate.currentCalendar().components(NSDate.componentFlags, fromDate: self)
        return components.minute
    }
    
    var hourString: String {
        return (self.hour < 10 ? "0" : "") + String(self.hour)
    }
    
    var minuteString: String {
        return (self.minute < 10 ? "0" : "") + String(self.minute)
    }
    
    func isEarlierThan(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedAscending
    }
    
    func isLaterThan(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedDescending
    }
    
    func dateByAdding(minutes minutes: Int) -> NSDate {
        let timeInterval = self.timeIntervalSinceReferenceDate + Double(60) * Double(minutes)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    func dateBySubstracting(minutes minutes: Int) -> NSDate {
        return self.dateByAdding(minutes: minutes * -1)
    }
    
    func dateByAdding(days days: Int) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.day = days
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0)) ?? self
    }
    
    func dateBySubstracting(days days: Int) -> NSDate {
        return self.dateByAdding(days: days * -1)
    }
}
