//
//  UIFont+EMAdditions.m
//  Embassat
//
//  Created by Joan Romano on 27/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "UIFont+EMAdditions.h"

static NSString *const NewBaskervilleRoman = @"NewBaskervilleStd-Roman";
static NSString *const NewBaskervilleBold = @"NewBaskervilleStd-Bold";

@implementation UIFont (EMAdditions)

+ (UIFont *)em_romanFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:NewBaskervilleRoman size:size];
}

+ (UIFont *)em_boldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:NewBaskervilleBold size:size];
}

@end
