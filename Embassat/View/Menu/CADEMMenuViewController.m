//
//  CADEMMenuViewController.m
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMenuViewController.h"

#import "CADEMMenuCollectionViewCell.h"
#import "CADEMArtistsViewController.h"
#import "CADEMScheduleViewController.h"
#import "CADEMScheduleViewModel.h"
#import "CADEMArtistsViewModel.h"
#import "CADEMInfoViewController.h"
#import "CADEMInfoViewModel.h"
#import "CADEMMapViewController.h"
#import "CADEMMapViewModel.h"
#import "CADEMTicketsViewController.h"
#import "CADEMExtrasViewController.h"

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

#pragma mark - Collection View

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id viewController;
    
    switch (indexPath.row)
    {
        case 0:
            viewController = [[CADEMInfoViewController alloc] init];
            ((CADEMInfoViewController *)viewController).viewModel = [[CADEMInfoViewModel alloc] init];
            break;
            
        case 1:
            viewController = [[CADEMArtistsViewController alloc] init];
            ((CADEMArtistsViewController *)viewController).viewModel = [[CADEMArtistsViewModel alloc] initWithModel:nil];
            break;
            
        case 2:
            viewController = [[CADEMScheduleViewController alloc] init];
            ((CADEMScheduleViewController *)viewController).viewModel = [[CADEMScheduleViewModel alloc] init];
            break;
            
        case 3:
            viewController = [[CADEMMapViewController alloc] init];
            ((CADEMMapViewController *)viewController).viewModel = [[CADEMMapViewModel alloc] init];
            break;
            
        case 4:
            viewController = [[CADEMTicketsViewController alloc] init];
            break;
            
        case 5:
            viewController = [[CADEMExtrasViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Lazy

- (CADArrayDataSourceSwift *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[CADArrayDataSourceSwift alloc] initWithViewModel:self.viewModel configureCellBlock:^(CADEMMenuCollectionViewCell *cell, NSIndexPath *indexPath) {
            cell.optionName = [self.viewModel titleAtIndexPath:indexPath];
            cell.hidesTopSeparator = indexPath.row == 0;
        } configureHeaderBlock:nil];
    }
    
    return _dataSource;
}

@end
