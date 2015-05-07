//
//  CADArrayDataSource.m
//  Embassat
//
//  Created by Joan Romano on 25/07/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "CADArrayDataSource.h"

NSString *const CADCellIdentifier = @"CellIdentifier";
NSString *const CADHeaderIdentifier = @"HeaderIdentifier";

@implementation NSObject (CADEMViewModelCollectionDelegate)

- (NSInteger)numberOfSections{return 1;}

@end

@interface CADArrayDataSource ()

@property (nonatomic, strong) id <CADEMViewModelCollectionDelegate> viewModel;
@property (nonatomic, copy) ConfigureViewBlock configureCellBlock;
@property (nonatomic, copy) ConfigureViewBlock configureHeaderBlock;

@end

@implementation CADArrayDataSource

#pragma mark - Init

- (instancetype)initWithViewModel:(id)viewModel
               configureCellBlock:(ConfigureViewBlock)configureBlock
{
    return [self initWithViewModel:viewModel configureCellBlock:configureBlock configureHeaderBlock:NULL];
}

- (instancetype)initWithViewModel:(id<CADEMViewModelCollectionDelegate>)viewModel configureCellBlock:(ConfigureViewBlock)configureBlock configureHeaderBlock:(ConfigureViewBlock)configureHeaderBlock
{
    if (self = [super init])
    {
        _viewModel = viewModel;
        _configureCellBlock = configureBlock;
        _configureHeaderBlock = configureHeaderBlock;
    }
    
    return self;
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:CADCellIdentifier forIndexPath:indexPath];

    self.configureCellBlock(cell, indexPath);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    id view;
    
    view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                              withReuseIdentifier:CADHeaderIdentifier
                                                     forIndexPath:indexPath];
    
    self.configureHeaderBlock(view, indexPath);
    
    return view;
}

@end
