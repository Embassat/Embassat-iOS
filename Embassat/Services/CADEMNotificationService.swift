//
//  CADEMNotificationService.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMNotificationService: NSObject {
    
    public func registerForLocalNotifications() {
        
        if UIApplication.sharedApplication().respondsToSelector("registerUserNotificationSettings:") {
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
        }
        
    }

    public func toggleLocalNotification(forArtist artist: CADEMArtistSwift, favorited: Bool) {
        var localNotif = UILocalNotification()
        
        localNotif.fireDate = NSDate().dateByAddingTimeInterval(10)
        localNotif.alertBody = String(format: "%@ començarà en 10 minuts al %@!", artist.name, artist.stage)
        localNotif.userInfo = ["artistId" : artist.artistId]
        localNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications: Array<UILocalNotification> = UIApplication.sharedApplication().scheduledLocalNotifications as! Array<UILocalNotification>
        
        if var existingNotification = existingNotifications.filter({ (notification: UILocalNotification) -> Bool in
            if let artistId = notification.userInfo?["artistId"] as? Int {
                return artistId == artist.artistId
            } else {
                return false
            }
        }).first {
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification)
            
            if favorited == true {
                existingNotification.fireDate = NSDate().dateByAddingTimeInterval(10)
                UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
            }
        } else {
            UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
        }
    }
}
