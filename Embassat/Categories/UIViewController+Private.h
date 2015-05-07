//
//  UIViewController+Private.h
//  YouBarcelona
//
//  Created by Joan Romano on 27/08/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

@interface UIViewController (Private)

@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGestureToResign;

- (void)loadData;

- (void)registerForKeyboardNotifications;
- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden
           withAnimationDuration:(NSTimeInterval)animationDuration
                           curve:(UIViewAnimationCurve)curve
                  keyboardHeight:(CGFloat)keyboardHeight;

- (void)showLoading;
- (void)hideLoading;
- (void)hideWithSuccess:(NSString *)success;
- (void)hideWithError:(NSString *)error;

@end
