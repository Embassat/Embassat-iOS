//
//  CADAppDelegate.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADAppDelegate.h"

#import <DDTTYLogger.h>

#import "CADEMRootNavigationController.h"
#import "CADEMMenuViewController.h"

#import "CADEMMenuViewModel.h"

@interface CADAppDelegate ()

@property (nonatomic, copy) CADEMRootNavigationController *rootNavigationController;

@end

@implementation CADAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    // OBConnection setup
    [OBConnection registerWithBaseUrl:[NSURL URLWithString:@"http://embassat.com/api/"]];
    
    [self setupAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = self.rootNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Private Methods

- (void)setupAppearance
{
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    UINavigationBar.appearance.barTintColor = [UIColor blackColor];
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont em_boldFontOfSize:16.0f]};
}

#pragma mark - Lazy

- (CADEMRootNavigationController *)rootNavigationController
{
    if (!_rootNavigationController)
    {
        CADEMMenuViewController *menuViewController = [[CADEMMenuViewController alloc] init];
        menuViewController.viewModel = [[CADEMMenuViewModel alloc] initWithModel:@[@"INFORMACIÓ", @"ARTISTES", @"HORARIS", @"MAPA", @"ENTRADES", @"EXTRES"]];
        
        _rootNavigationController = [[CADEMRootNavigationController alloc] initWithRootViewController:menuViewController];
    }
    
    return _rootNavigationController;
}

@end
