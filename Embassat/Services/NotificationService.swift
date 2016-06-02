//
//  NotificationService.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import UIKit

struct NotificationService {
    
    let dateFormatter = NSDateFormatter()
    
    func registerForLocalNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
        scheduleAfterPartyNotification()
    }
    
    private func scheduleAfterPartyNotification() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let localAfterPartyNotif = UILocalNotification()
        
        localAfterPartyNotif.fireDate = dateFormatter.dateFromString("2016-06-12T02:30:00")
        localAfterPartyNotif.alertBody = String(format: "Seapoint començarà en 15 minuts al Sala Oui!")
        localAfterPartyNotif.userInfo = ["artistName" : "seapoint"]
        localAfterPartyNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        if let afterPartyExistingNotification = existingNotifications.filter({ notification -> Bool in
            if let artistName = notification.userInfo?["artistName"] as? String {
                return artistName == "seapoint"
            } else {
                return false
            }
        }).first {
            UIApplication.sharedApplication().cancelLocalNotification(afterPartyExistingNotification)
            UIApplication.sharedApplication().scheduleLocalNotification(localAfterPartyNotif)
        } else {
            UIApplication.sharedApplication().scheduleLocalNotification(localAfterPartyNotif)
        }
    }

    func toggleLocalNotification(forArtist artist: CADEMArtist, favorited: Bool) {
        guard artist.name != "Seapoint" else { return }
        
        let localNotif = UILocalNotification()
        
        localNotif.fireDate = artist.startDate.dateBySubstracting(minutes: 15)
        localNotif.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
        localNotif.userInfo = ["artistId" : artist.artistId]
        localNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        if let existingNotification = existingNotifications.filter({ (notification: UILocalNotification) -> Bool in
            if let artistId = notification.userInfo?["artistId"] as? Int {
                return artistId == artist.artistId
            } else {
                return false
            }
        }).first {
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification)
            
            if favorited == true {
                UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
            }
        } else {
            UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
        }
    }
    
    func updateLocalNotifications(forArtists artists: [CADEMArtist]) {
        let existingNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in existingNotifications {
            if let artist = artists.filter({ (artist: CADEMArtist) -> Bool in
                if let artistId = notification.userInfo?["artistId"] as? Int {
                    return artistId == artist.artistId
                } else {
                    return false
                }
            }).first {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                notification.fireDate = artist.startDate.dateBySubstracting(minutes: 15)
                notification.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
    }
}
