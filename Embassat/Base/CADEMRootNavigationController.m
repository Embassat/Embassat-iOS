//
//  CADEMRootNavigationController.m
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMRootNavigationController.h"

@interface CADEMRootNavigationController ()

@end

@implementation CADEMRootNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
