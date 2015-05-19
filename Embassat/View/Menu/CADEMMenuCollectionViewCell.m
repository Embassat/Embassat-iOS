//
//  CADEMMenuCollectionViewCell.m
//  Embassat
//
//  Created by Joan Romano on 09/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMenuCollectionViewCell.h"

#import "UIColor+EMAdditions.h"

@interface CADEMMenuCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *optionNameLabel;

@end

@implementation CADEMMenuCollectionViewCell

- (void)setupView
{
    RAC(self.optionNameLabel, text) = RACObserve(self, optionName);
    
    self.optionNameLabel.font = [UIFont em_titleFontOfSize:30.0f];
    self.optionNameLabel.adjustsFontSizeToFitWidth = YES;
    
    RAC(self, optionNameLabel.textColor) =
    [RACSignal
     combineLatest:@[RACObserve(self, selected), RACObserve(self, highlighted)]
     reduce:^id(NSNumber *selected, NSNumber *highlighted){
         return selected.boolValue || highlighted.boolValue ? [UIColor em_barTintColor] : [UIColor whiteColor];
     }];
}

@end
