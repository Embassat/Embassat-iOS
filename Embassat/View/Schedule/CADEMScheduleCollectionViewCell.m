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

@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel, *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel, *stageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *favoriteImageView;

@end

@implementation CADEMScheduleCollectionViewCell

- (void)setupView
{
    [super setupView];
    
    RAC(self.startTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self, initialHour), RACObserve(self, initialMinute)]] map:^id(RACTuple *tuple) {
        return [NSString stringWithFormat:@"%@:%@", tuple.first, tuple.second];
    }];
    RAC(self.endTimeLabel, text) = [[RACSignal combineLatest:@[RACObserve(self, finalHour), RACObserve(self, finalMinute)]] map:^id(RACTuple *tuple) {
        return [NSString stringWithFormat:@"%@:%@", tuple.first, tuple.second];
    }];
    RAC(self.artistNameLabel, text) = [RACObserve(self, artistName) ignore:nil];
    RAC(self.stageLabel, text) = [RACObserve(self, stageName) ignore:nil];
    RAC(self.favoriteImageView, hidden) = [RACObserve(self, shouldShowFavorite) not];
    
    self.startTimeLabel.font = self.endTimeLabel.font = self.artistNameLabel.font = self.stageLabel.font = [UIFont em_detailFontOfSize:15.0f];
    self.artistNameLabel.adjustsFontSizeToFitWidth = YES;
}

@end
