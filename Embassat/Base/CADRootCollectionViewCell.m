//
//  CADRootCollectionViewCell.m
//  CanBuxeres
//
//  Created by Joan Romano on 01/10/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "CADRootCollectionViewCell.h"

@implementation CADRootCollectionViewCell

#pragma mark - Overridden

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView{}

@end
