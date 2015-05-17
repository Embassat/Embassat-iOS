//
//  CADEMShareKitConfigurator.m
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

#import "CADEMShareKitConfigurator.h"

@implementation CADEMShareKitConfigurator

- (NSString*)facebookAppId
{
    return @"388219104649367";
}

- (NSArray*)defaultFavoriteURLSharers
{
    return @[@"SHKTwitter",@"SHKFacebook", @"SHKiOSTwitter",@"SHKiOSFacebook"];
}

- (NSNumber*)showActionSheetMoreButton
{
    return @(NO);
}

- (NSString*)twitterConsumerKey
{
    return @"uYRWKK8XHEEw5gho0p6YsCfGK";
}

- (NSString*)twitterCallbackUrl
{
    return @"http://twitter.sharekit.com";
}

- (NSNumber*)twitterUseXAuth
{
    return [NSNumber numberWithInt:0];
}

- (NSString*)twitterUsername
{
    return @"";
}

@end
