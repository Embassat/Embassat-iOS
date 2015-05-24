//
//  CADEMScheduleViewController.m
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMScheduleViewController.h"

#import "CADArrayDataSource.h"
#import "CADEMScheduleViewModel.h"
#import "CADEMScheduleHeaderView.h"
#import "CADEMScheduleCollectionViewCell.h"

@interface CADEMScheduleViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *scheduleCollectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CADArrayDataSource *dataSource;

@end

@implementation CADEMScheduleViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"Horaris";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scheduleCollectionView.dataSource = self.dataSource;
    [self.scheduleCollectionView registerNib:[UINib nibWithNibName:@"CADEMScheduleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CADCellIdentifier];
    [self.scheduleCollectionView registerNib:[UINib nibWithNibName:@"CADEMScheduleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CADHeaderIdentifier];
    
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activityIndicator stopAnimating];
        [self.scheduleCollectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.viewModel.active = YES;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CADEMArtistDetailViewController *artistDetailViewController = [[CADEMArtistDetailViewController alloc] initWithNibName:@"CADEMArtistDetailViewController" bundle:nil];
    artistDetailViewController.viewModel = [self.viewModel artistViewModelForIndexPath:indexPath];
    
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

#pragma mark - Lazy

- (CADArrayDataSource *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[CADArrayDataSource alloc] initWithViewModel:self.viewModel configureCellBlock:^(CADEMScheduleCollectionViewCell *cell, NSIndexPath *indexPath) {
            cell.initialHour = [self.viewModel initialHourAtIndexPath:indexPath];
            cell.initialMinute = [self.viewModel initialMinuteAtIndexPath:indexPath];
            cell.finalHour = [self.viewModel finalHourAtIndexPath:indexPath];
            cell.finalMinute = [self.viewModel finalMinuteAtIndexPath:indexPath];
            cell.artistName = [self.viewModel artistNameAtIndexPath:indexPath];
            cell.stageName = [self.viewModel stageNameAtIndexPath:indexPath];
            cell.shouldShowFavorite = [self.viewModel favoritedStatusAtIndexPath:indexPath];
            cell.backgroundColor = [self.viewModel backgroundColorAtIndexPath:indexPath];
        } configureHeaderBlock:^(CADEMScheduleHeaderView *headerView, id indexPath) {
            [headerView.daySelectedSignal subscribeNext:^(id x) {
                self.viewModel.dayIndex = [x integerValue];
                [self.scheduleCollectionView reloadData];
            }];
        }];
    }
    
    return _dataSource;
}

@end
