//
//  CADAppDelegate.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADAppDelegate.h"

#import "UIColor+EMAdditions.h"

#import <ShareKit/ShareKit.h>
#import <ShareKit/SHKConfiguration.h>
#import <ShareKit/SHKFacebook.h>

@interface CADAppDelegate ()

@property (nonatomic, copy) CADEMRootNavigationController *rootNavigationController;

@end

@implementation CADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[CADEMNotificationService alloc] init] registerForLocalNotifications];
    [SHKConfiguration sharedInstanceWithConfigurator:[[CADEMShareKitConfigurator alloc] init]];
    
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
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    UINavigationBar.appearance.barTintColor = [UIColor em_barTintColor];
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont detailFontOfSize:30.0f]};
}

#pragma mark - Lazy

- (CADEMRootNavigationController *)rootNavigationController
{
    if (!_rootNavigationController)
    {
        CADEMMenuViewController *menuViewController = [[CADEMMenuViewController alloc] initWithNibName:@"CADEMMenuViewController" bundle:nil];
        
        _rootNavigationController = [[CADEMRootNavigationController alloc] initWithRootViewController:menuViewController];
    }
    
    return _rootNavigationController;
}

@end
