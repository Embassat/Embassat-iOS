//
//  CADEMMenuCollectionViewCell.m
//  Embassat
//
//  Created by Joan Romano on 09/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMenuCollectionViewCell.h"

@interface CADEMMenuCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView *topSeparator;
@property (nonatomic, weak) IBOutlet UILabel *optionNameLabel;

@end

@implementation CADEMMenuCollectionViewCell

- (void)setupView
{
    RAC(self.topSeparator, hidden) = RACObserve(self, hidesTopSeparator);
    RAC(self.optionNameLabel, text) = RACObserve(self, optionName);
    
    self.optionNameLabel.font = [UIFont em_titleFontOfSize:16.0f];
    self.optionNameLabel.adjustsFontSizeToFitWidth = YES;
}

@end
