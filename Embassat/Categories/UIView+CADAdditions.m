//
//  UIView+CADAdditions.m
//  YouBarcelona
//
//  Created by Joan Romano on 31/07/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "UIView+CADAdditions.h"

@implementation UIView (CADAdditions)

/**
 Get the current first responder without using a private API
 
 http://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
 */
- (UIView *)findFirstResponder
{
    if (self.isFirstResponder)
        return self;
    
    for (UIView *subView in self.subviews)
    {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil)
        {
            return firstResponder;
        }
    }
    
    return nil;
}

- (UIScrollView *)findParentScrollView
{
    if ([self isKindOfClass:[UIScrollView class]])
        return (UIScrollView *)self;
    
    if (self.superview)
    {
        return [self.superview findParentScrollView];
    }
    
    return nil;
}

@end
