//
//  CADEMShareKitConfigurator.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMShareKitConfigurator: DefaultSHKConfigurator {
    
    public override func facebookAppId() -> String {
        return "388219104649367"
    }
    
    public override func defaultFavoriteURLSharers() -> [AnyObject] {
        return ["SHKTwitter", "SHKFacebook", "SHKiOSTwitter", "SHKiOSFacebook"]
    }
    
    public override func showActionSheetMoreButton() -> NSNumber {
        return false
    }
    
    public override func twitterConsumerKey() -> String {
        return "uYRWKK8XHEEw5gho0p6YsCfGK"
    }
    
    public override func twitterCallbackUrl() -> String {
        return "http://twitter.sharekit.com"
    }
    
    public override func twitterUseXAuth() -> NSNumber {
        return 0
    }
    
    public override func twitterUsername() -> String {
        return ""
    }
}
