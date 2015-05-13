//
//  CADRootViewController.m
//  YouBarcelona
//
//  Created by Joan Romano on 22/07/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "CADRootViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import "UIView+CADAdditions.h"

@interface CADRootViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureToResign;

@end

@implementation CADRootViewController

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.tapGestureToResign];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowOrHideNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowOrHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden
           withAnimationDuration:(NSTimeInterval)animationDuration
                           curve:(UIViewAnimationCurve)curve
                  keyboardHeight:(CGFloat)keyboardHeight
{
    UIEdgeInsets insets;
    UIView *firstResponder;
    UIScrollView *parentScrollView;
    
    firstResponder = [self.view findFirstResponder];
    parentScrollView = [firstResponder findParentScrollView];
    
    if (parentScrollView)
    {
        insets = UIEdgeInsetsZero;
        insets.top = self.topLayoutGuide.length;
        insets.bottom = keyboardHidden ? 0.0 : keyboardHeight;
        [UIView animateWithDuration:animationDuration animations:^{
            parentScrollView.contentInset = insets;
            parentScrollView.scrollIndicatorInsets = insets;
        } completion:^(BOOL finished) {
            if (!keyboardHidden)
            {
                [parentScrollView scrollRectToVisible:[firstResponder.superview convertRect:firstResponder.frame
                                                                                     toView:parentScrollView]
                                             animated:YES];
            }
        }];
    }
}

#pragma mark - Progress HUD

- (void)showLoading
{
    [SVProgressHUD show];
}

- (void)hideLoading
{
    [SVProgressHUD dismiss];
}

- (void)hideWithSuccess:(NSString *)success
{
    [SVProgressHUD showSuccessWithStatus:success];
}

- (void)hideWithError:(NSString *)error
{
    [SVProgressHUD showErrorWithStatus:error];
}

#pragma mark - Network Load

- (void)loadData{}

#pragma mark - Private Methods

- (void)tapRecognizerToResignFieldsDidTrigger
{
    [self.view endEditing:YES];
}

- (void)keyboardShowOrHideNotification:(NSNotification *)notification
{
    [self keyboardWillBecomeHidden:[notification.name isEqualToString:UIKeyboardWillHideNotification]
              withNotificationInfo:[notification userInfo]];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withNotificationInfo:(NSDictionary *)notificationInfo
{
    UIViewAnimationCurve animationCurve; [[notificationInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect keyboardFrameAtEndOfAnimation; [[notificationInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameAtEndOfAnimation];
    CGFloat keyboardHeight = keyboardFrameAtEndOfAnimation.size.height;
    
    NSTimeInterval animationDuration = [[notificationInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self keyboardWillBecomeHidden:keyboardHidden withAnimationDuration:animationDuration curve:animationCurve keyboardHeight:keyboardHeight];
}

#pragma mark - Lazy

- (UITapGestureRecognizer *)tapGestureToResign
{
    if (!_tapGestureToResign)
    {
        _tapGestureToResign = [[UITapGestureRecognizer alloc] init];
        _tapGestureToResign.cancelsTouchesInView = NO;
        [_tapGestureToResign addTarget:self action:@selector(tapRecognizerToResignFieldsDidTrigger)];
        [self.view addGestureRecognizer:_tapGestureToResign];
    }
    
    return _tapGestureToResign;
}

@end
