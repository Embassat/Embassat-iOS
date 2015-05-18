//
//  UIFont+EMAdditions.m
//  Embassat
//
//  Created by Joan Romano on 27/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "UIFont+EMAdditions.h"

static NSString *const ApercuMedium = @"Apercu-Medium";
static NSString *const NoeDisplayBold = @"NoeDisplay-Bold";

@implementation UIFont (EMAdditions)

+ (UIFont *)em_detailFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:ApercuMedium size:size];
}

+ (UIFont *)em_titleFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:NoeDisplayBold size:size];
}

@end
