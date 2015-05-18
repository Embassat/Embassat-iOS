//
//  CADEMScheduleCollectionViewCell.m
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMScheduleCollectionViewCell.h"

#import "UIView+AutoLayout.h"

@interface CADEMScheduleCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView *leftSeparatorView;
@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel, *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel, *stageLabel;

@end

@implementation CADEMScheduleCollectionViewCell

- (void)setupView
{
    [super setupView];
    
    RAC(self.leftSeparatorView, backgroundColor) = [RACObserve(self, leftColor) ignore:nil];
    
    RAC(self.startTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self, initialHour), RACObserve(self, initialMinute)]] map:^id(RACTuple *tuple) {
        return [NSString stringWithFormat:@"%@:%@", tuple.first, tuple.second];
    }];
    RAC(self.endTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self, finalHour), RACObserve(self, finalMinute)]] map:^id(RACTuple *tuple) {
        return [NSString stringWithFormat:@"%@:%@", tuple.first, tuple.second];
    }];
    RAC(self.artistNameLabel, text) = [RACObserve(self, artistName) ignore:nil];
    RAC(self.stageLabel, text) = [RACObserve(self, stageName) ignore:nil];
    
    self.startTimeLabel.font = self.endTimeLabel.font = self.artistNameLabel.font = [UIFont em_titleFontOfSize:16.0f];
    self.stageLabel.font = [UIFont em_detailFontOfSize:16.0f];
    self.artistNameLabel.adjustsFontSizeToFitWidth = YES;
}

@end
