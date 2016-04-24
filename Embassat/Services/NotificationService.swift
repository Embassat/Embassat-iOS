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
    
    func registerForLocalNotifications() {
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
        
    }

    func toggleLocalNotification(forArtist artist: CADEMArtist, favorited: Bool) {
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
