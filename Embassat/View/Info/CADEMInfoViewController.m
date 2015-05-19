//
//  CADEMInfoViewController.m
//  Embassat
//
//  Created by Joan Romano on 30/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMInfoViewController.h"

#import "CADEMInfoCollectionViewCell.h"
#import "CADEMInfoHeaderView.h"
#import "CADArrayDataSource.h"

#import "CADEMInfoViewModel.h"

@interface CADEMInfoViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *infoCollectionView;
@property (nonatomic, strong) CADEMInfoCollectionViewCell *prototypeCell;

@property (nonatomic, strong) CADArrayDataSource *dataSource;

@end

@implementation CADEMInfoViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"Info";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoCollectionView.dataSource = self.dataSource;
    [self.infoCollectionView registerNib:[UINib nibWithNibName:@"CADEMInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CADCellIdentifier];
    [self.infoCollectionView registerNib:[UINib nibWithNibName:@"CADEMInfoHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CADHeaderIdentifier];
    self.prototypeCell = [[[UINib nibWithNibName:@"CADEMInfoCollectionViewCell" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.body = [self.viewModel bodyAtIndexPath:indexPath];
    
    return [self.prototypeCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

#pragma mark - Lazy

- (CADArrayDataSource *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[CADArrayDataSource alloc] initWithViewModel:self.viewModel configureCellBlock:^(CADEMInfoCollectionViewCell *cell, id indexPath) {
            cell.body = [self.viewModel bodyAtIndexPath:indexPath];
        } configureHeaderBlock:^(CADEMInfoHeaderView *header, id indexPath) {
            header.title = [self.viewModel titleAtIndexPath:indexPath];
            header.cover = [self.viewModel imageAtIndexPath:indexPath];
        }];
    }
    
    return _dataSource;
}

@end
