//
//  CADEMMenuViewController.m
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMenuViewController.h"

#import "CADEMMenuCollectionViewCell.h"
#import "CADEMScheduleViewController.h"
#import "CADEMScheduleViewModel.h"

#import "UICollectionViewFlowLayout+EMAdditions.h"

@interface CADEMMenuViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *menuCollectionView;

@property (nonatomic, strong) CADArrayDataSourceSwift *dataSource;

@end

@implementation CADEMMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.menuCollectionView.dataSource = self.dataSource;
    [self.menuCollectionView registerNib:[UINib nibWithNibName:@"CADEMMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CADArrayDataSourceSwift.CADCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (NSIndexPath *indexPath in self.menuCollectionView.indexPathsForSelectedItems)
    {
        [self.menuCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - Collection View

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id viewController;
    
    switch (indexPath.row)
    {
        case 0:
            viewController = [[CADEMInfoViewController alloc] initWithNibName:@"CADEMInfoViewController" bundle:nil];
            break;
            
        case 1:
            viewController = [[CADEMArtistsViewController alloc] initWithNibName:@"CADEMArtistsViewController" bundle:nil];
            break;
            
        case 2:
            viewController = [[CADEMScheduleViewController alloc] init];
            ((CADEMScheduleViewController *)viewController).viewModel = [[CADEMScheduleViewModel alloc] init];
            break;
            
        case 3:
            viewController = [[CADEMMapViewController alloc] initWithNibName:@"CADEMMapViewController" bundle:nil];
            break;
            
        case 4:
            viewController = [[CADEMTicketsViewController alloc] initWithNibName:@"CADEMTicketsViewController" bundle:nil];
            break;
            
        case 5:
            viewController = [[CADEMExtrasViewController alloc] initWithNibName:@"CADEMExtrasViewController" bundle:nil];
            break;
            
        default:
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UICollectionViewFlowLayout Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    return [flowLayout insetsForVerticallyCenteredSectionInScreenWithRows:[self.dataSource.viewModel numberOfItemsInSection:0] andColumns:[self.dataSource.viewModel numberOfSections]];
}

#pragma mark - Lazy

- (CADArrayDataSourceSwift *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[CADArrayDataSourceSwift alloc] initWithViewModel:self.viewModel configureCellBlock:^(CADEMMenuCollectionViewCell *cell, NSIndexPath *indexPath) {
            cell.optionName = [self.viewModel titleAtIndexPath:indexPath];
        } configureHeaderBlock:nil];
    }
    
    return _dataSource;
}

@end
