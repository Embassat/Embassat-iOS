//
//  CADAppDelegate.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADAppDelegate.h"

#import <ShareKit/ShareKit.h>
#import <ShareKit/SHKConfiguration.h>
#import <ShareKit/SHKFacebook.h>

@interface CADAppDelegate ()

@property (nonatomic, copy) RootNavigationController *rootNavigationController;

@end

@implementation CADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[NotificationService alloc] init] registerForLocalNotifications];
    [SHKConfiguration sharedInstanceWithConfigurator:[[ShareKitConfigurator alloc] init]];
    
    [self setupAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = self.rootNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [SHKFacebook handleWillTerminate];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url scheme] hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]])
    {
        return [SHKFacebook handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    return YES;
}

#pragma mark - Private Methods

- (void)setupAppearance
{
    UINavigationBar.appearance.translucent = NO;
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    UINavigationBar.appearance.barTintColor = [UIColor emBarTintColor];
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont detailFontOfSize:30.0f]};
}

#pragma mark - Lazy

- (RootNavigationController *)rootNavigationController
{
    if (!_rootNavigationController)
    {
        _rootNavigationController = [[RootNavigationController alloc] initWithRootViewController:[[MenuViewController alloc] init]];
    }
    
    return _rootNavigationController;
}

@end
