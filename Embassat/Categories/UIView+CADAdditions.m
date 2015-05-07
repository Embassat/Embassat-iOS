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

- (UICollectionView *)superCollectionView
{
	UIView *superview = self.superview;
    
	while (superview != nil)
    {
		if ([superview isKindOfClass:[UICollectionView class]])
        {
			return (id)superview;
		}
        
		superview = [superview superview];
	}
    
	return nil;
}

- (UIView *)searchBarBackgroundView
{
    UIView *view = nil;
    
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            view = subview;
            break;
        }
        else
        {
            view = [subview searchBarBackgroundView];
        }
    }
    
    return view;
}

- (UITextField *)textField
{
    UITextField *view = nil;
    
    for(UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            view = (UITextField *)subview;
            break;
        }
        else
        {
            view = [subview textField];
        }
    }
    
    return view;
}

- (UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *imageFromCurrentView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageFromCurrentView;
}

/**
 Remove clear button (grey x) to the right of UISearchBar when cancel button tapped
 
 http://stackoverflow.com/a/19458201/1116264
 */
- (void)removeSearchBarClearButtonWhileEditing
{
    for (UIView *subview in self.subviews)
    {
        [subview removeSearchBarClearButtonWhileEditing];
    }
    
    if ([self conformsToProtocol:@protocol(UITextInputTraits)] && [self respondsToSelector:@selector(setClearButtonMode:)])
    {
        [(UITextField *)self setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
}

@end
