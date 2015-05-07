//
//  UIView+CADAdditions.h
//  YouBarcelona
//
//  Created by Joan Romano on 31/07/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

@interface UIView (CADAdditions)

/**
 Get the current first responder without using a private API
 */
- (UIView *)findFirstResponder;

/**
 Get the first parent scroll view
 */
- (UIScrollView *)findParentScrollView;

@end
