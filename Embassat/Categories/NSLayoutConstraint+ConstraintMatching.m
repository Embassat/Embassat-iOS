//
//  NSLayoutConstraint+ConstraintMatching.m
//  Embassat
//
//  Created by Joan Romano on 21/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "NSLayoutConstraint+ConstraintMatching.h"

@implementation NSLayoutConstraint (ConstraintMatching)

- (BOOL)refersToView:(UIView *)theView
{
    if (!theView)
        return NO;
    if (!self.firstItem) // shouldn't happen. Illegal
        return NO;
    if (self.firstItem == theView)
        return YES;
    if (!self.secondItem)
        return NO;
    return (self.secondItem == theView);
}

@end
