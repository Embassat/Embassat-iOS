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
    
    let dateFormatter = DateFormatter()
    
    func registerForLocalNotifications() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        scheduleAfterPartyNotification()
    }
    
    fileprivate func scheduleAfterPartyNotification() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let localAfterPartyNotif = UILocalNotification()
        
        localAfterPartyNotif.fireDate = dateFormatter.date(from: "2016-06-12T02:30:00")
        localAfterPartyNotif.alertBody = String(format: "Seapoint començarà en 30 minuts al Sala Oui!")
        localAfterPartyNotif.userInfo = ["artistName" : "seapoint"]
        localAfterPartyNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        if let afterPartyExistingNotification = existingNotifications.filter({ notification -> Bool in
            if let artistName = notification.userInfo?["artistName"] as? String {
                return artistName == "seapoint"
            } else {
                return false
            }
        }).first {
            UIApplication.shared.cancelLocalNotification(afterPartyExistingNotification)
            UIApplication.shared.scheduleLocalNotification(localAfterPartyNotif)
        } else {
            UIApplication.shared.scheduleLocalNotification(localAfterPartyNotif)
        }
    }

    func toggleLocalNotification(forArtist artist: CADEMArtist, favorited: Bool) {
        guard artist.name != "Seapoint" else { return }
        
        let localNotif = UILocalNotification()
        
        localNotif.fireDate = artist.startDate.dateBySubstracting(minutes: 15) as Date
        localNotif.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
        localNotif.userInfo = ["artistId" : artist.artistId]
        localNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        if let existingNotification = existingNotifications.filter({ (notification: UILocalNotification) -> Bool in
            if let artistId = notification.userInfo?["artistId"] as? Int {
                return artistId == artist.artistId
            } else {
                return false
            }
        }).first {
            UIApplication.shared.cancelLocalNotification(existingNotification)
            
            if favorited == true {
                UIApplication.shared.scheduleLocalNotification(localNotif)
            }
        } else {
            UIApplication.shared.scheduleLocalNotification(localNotif)
        }
    }
    
    func updateLocalNotifications(forArtists artists: [CADEMArtist]) {
        let existingNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        for notification in existingNotifications {
            if let artist = artists.filter({ (artist: CADEMArtist) -> Bool in
                if let artistId = notification.userInfo?["artistId"] as? Int {
                    return artistId == artist.artistId
                } else {
                    return false
                }
            }).first {
                UIApplication.shared.cancelLocalNotification(notification)
                notification.fireDate = artist.startDate.dateBySubstracting(minutes: 15) as Date
                notification.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }
}
