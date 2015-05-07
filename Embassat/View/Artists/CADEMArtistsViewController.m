//
//  CADEMArtistsViewController.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMArtistsViewController.h"

#import "CADArrayDataSource.h"
#import "CADEMMenuCollectionViewCell.h"
#import "CADEMArtistDetailViewController.h"

#import "CADEMArtistsViewModel.h"
#import "CADEMArtistDetailViewModel.h"

@interface CADEMArtistsViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *artistsCollectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CADArrayDataSource *dataSource;

@end

@implementation CADEMArtistsViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"ARTISTES";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.artistsCollectionView.dataSource = self.dataSource;
    [self.artistsCollectionView registerNib:[UINib nibWithNibName:@"CADEMMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CADCellIdentifier];

    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.activityIndicator stopAnimating];
        [self.artistsCollectionView reloadData];
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
    CADEMArtistDetailViewController *artistDetailViewController = [[CADEMArtistDetailViewController alloc] init];
    artistDetailViewController.viewModel = [self.viewModel artistViewModelForIndexPath:indexPath];
    
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

#pragma mark - Lazy

- (CADArrayDataSource *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[CADArrayDataSource alloc] initWithViewModel:self.viewModel configureCellBlock:^(CADEMMenuCollectionViewCell *cell, NSIndexPath *indexPath) {
            cell.optionName = [self.viewModel titleAtIndexPath:indexPath];
            cell.hidesTopSeparator = indexPath.row == 0;
        }];
    }
    
    return _dataSource;
}

@end
