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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
    
    func registerForLocalNotifications() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
    }

    func toggleLocalNotification(forArtist artist: CADEMArtist, favorited: Bool) {
        guard artist.name != "Seapoint" else { return }
        
        let localNotif = UILocalNotification()
        localNotif.fireDate = artist.startDate.dateBySubstracting(minutes: 15) as Date
        localNotif.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
        localNotif.setArtistId(artist.artistId)
        localNotif.soundName = UILocalNotificationDefaultSoundName
        
        let existingNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        if let existingNotification = existingNotifications.first(where: { $0.artistId == artist.artistId }) {
            UIApplication.shared.cancelLocalNotification(existingNotification)
            
            if favorited {
                UIApplication.shared.scheduleLocalNotification(localNotif)
            }
        } else {
            UIApplication.shared.scheduleLocalNotification(localNotif)
        }
    }
    
    func updateLocalNotifications(forArtists artists: [CADEMArtist]) {
        let existingNotifications = UIApplication.shared.scheduledLocalNotifications!
        
        for notification in existingNotifications {
            guard let artistId = notification.artistId else { break }
            
            if let artist = artists.first(where: { artistId == $0.artistId }) {
                UIApplication.shared.cancelLocalNotification(notification)
                notification.fireDate = artist.startDate.dateBySubstracting(minutes: 15) as Date
                notification.alertBody = String(format: "%@ començarà en 15 minuts al %@!", artist.name, artist.stage)
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }
}

private extension UILocalNotification {
    
    var artistId: Int? {
        return userInfo?["artistId"] as? Int
    }
    
    var artistName: String? {
        return userInfo?["artistName"] as? String
    }
    
    func setArtistId(_ artistId: Int) {
        userInfo = ["artistId" : artistId]
    }
    
    func setArtistName(_ artistName: String) {
        userInfo = ["artistName" : artistName]
    }
    
}
