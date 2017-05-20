//
//  NSDate+EMAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import Foundation

extension Date {
    
    private static let componentFlags: Set<Calendar.Component> = [.year,
                                                                      .month,
                                                                      .day,
                                                                      .weekOfMonth,
                                                                      .hour,
                                                                      .minute,
                                                                      .second,
                                                                      .weekday,
                                                                      .weekdayOrdinal]
    
    private var dateComponents: DateComponents {
        return Calendar.autoupdatingCurrent.dateComponents(Date.componentFlags, from: self)
    }
    
    var day: Int {
        return dateComponents.day!
    }
    
    var hour: Int {
        return dateComponents.hour!
    }
    
    var minute: Int {
        return dateComponents.minute!
    }
    
    var hourString: String {
        return (hour < 10 ? "0" : "") + String(hour)
    }
    
    var minuteString: String {
        return (minute < 10 ? "0" : "") + String(minute)
    }
    
    func isEarlierThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func isLaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func dateByAdding(minutes: Int) -> Date {
        let timeInterval = timeIntervalSinceReferenceDate + Double(60) * Double(minutes)
        
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    func dateBySubstracting(minutes: Int) -> Date {
        return dateByAdding(minutes: minutes * -1)
    }
    
    func dateByAdding(days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        return Calendar.autoupdatingCurrent.date(byAdding: dateComponents, to: self) ?? self
    }
    
    func dateBySubstracting(days: Int) -> Date {
        return self.dateByAdding(days: days * -1)
    }
}
