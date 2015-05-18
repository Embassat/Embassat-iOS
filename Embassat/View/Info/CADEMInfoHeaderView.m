//
//  CADEMInfoHeaderView.m
//  Embassat
//
//  Created by Joan Romano on 13/04/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMInfoHeaderView.h"

@interface CADEMInfoHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *coverImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation CADEMInfoHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    RAC(self.titleLabel, text) = RACObserve(self, title);
    RAC(self.coverImage, image) = RACObserve(self, cover);
    
    self.titleLabel.font = [UIFont em_titleFontOfSize:16.0f];
}

@end
