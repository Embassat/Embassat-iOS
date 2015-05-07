//
//  CADEMInfoCollectionViewCell.m
//  Embassat
//
//  Created by Joan Romano on 13/04/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMInfoCollectionViewCell.h"

@interface CADEMInfoCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;

@end

@implementation CADEMInfoCollectionViewCell

- (void)setupView
{
    [super setupView];
    
    RAC(self.bodyLabel, text) = RACObserve(self, body);
    
    self.bodyLabel.font = [UIFont em_romanFontOfSize:16.0f];
}

@end
