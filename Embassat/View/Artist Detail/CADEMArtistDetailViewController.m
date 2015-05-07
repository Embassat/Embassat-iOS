//
//  CADEMArtistDetailViewController.m
//  Embassat
//
//  Created by Joan Romano on 26/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMArtistDetailViewController.h"

#import "CADEMArtistDetailViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CADEMArtistDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;;
@property (nonatomic, weak) IBOutlet UIImageView *coverImage;
@property (nonatomic, weak) IBOutlet UIView *infoView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel, *dayLabel, *timeLabel, *stageLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton, *addButton;

@end

@implementation CADEMArtistDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self)
    
    self.scrollView.scrollIndicatorInsets = (UIEdgeInsets){
        .top = CGRectGetHeight(self.coverImage.bounds) + CGRectGetHeight(self.infoView.bounds),
        .bottom = CGRectGetHeight(self.addButton.bounds)
    };
    
    self.descriptionLabel.font = [UIFont em_romanFontOfSize:16.0f];
    self.stageLabel.font = self.dayLabel.font = self.timeLabel.font = self.shareButton.titleLabel.font = self.addButton.titleLabel.font = [UIFont em_boldFontOfSize:16.0f];
    
    self.title = [self.viewModel.artistName uppercaseString];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.coverImage sd_setImageWithURL:self.viewModel.artistImageURL placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    self.stageLabel.text = self.viewModel.artistStage;
    self.dayLabel.text = self.viewModel.artistDay;
    self.descriptionLabel.text = self.viewModel.artistDescription;
    self.timeLabel.text = [NSString stringWithFormat:@"%@.%@", self.viewModel.artistStartHour, self.viewModel.artistStartMinute];
    
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel addEventOnCalendar];
    }];
}

@end
