//
//  CADEMArtistCollectionViewCell.m
//  Embassa't
//
//  Created by Joan Romano on 19/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

#import "CADEMArtistCollectionViewCell.h"

@interface CADEMArtistCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *optionNameLabel;

@end

@implementation CADEMArtistCollectionViewCell

- (void)setupView
{
    RAC(self.optionNameLabel, text) = RACObserve(self, optionName);
    
    self.optionNameLabel.font = [UIFont em_titleFontOfSize:16.0f];
    self.optionNameLabel.adjustsFontSizeToFitWidth = YES;
}

@end
