//
//  ShareKitConfigurator.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import ShareKit

class ShareKitConfigurator: DefaultSHKConfigurator {
    
    override func facebookAppId() -> String {
        return "388219104649367"
    }
    
    override func defaultFavoriteURLSharers() -> [Any] {
        return ["SHKTwitter" as AnyObject, "SHKFacebook" as AnyObject, "SHKiOSTwitter" as AnyObject, "SHKiOSFacebook" as AnyObject]
    }
    
    override func showActionSheetMoreButton() -> NSNumber {
        return false
    }
    
    override func twitterConsumerKey() -> String {
        return "uYRWKK8XHEEw5gho0p6YsCfGK"
    }
    
    override func twitterCallbackUrl() -> String {
        return "http://twitter.sharekit.com"
    }
    
    override func twitterUseXAuth() -> NSNumber {
        return 0
    }
    
    override func twitterUsername() -> String {
        return ""
    }
}
