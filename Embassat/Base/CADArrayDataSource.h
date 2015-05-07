//
//  CADArrayDataSource.h
//  Embassat
//
//  Created by Joan Romano on 25/07/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "CADEMViewModelCollectionDelegate.h"

typedef void (^ConfigureViewBlock)(id view, id indexPath);

extern NSString *const CADCellIdentifier;
extern NSString *const CADHeaderIdentifier;

@interface CADArrayDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong, readonly) id <CADEMViewModelCollectionDelegate> viewModel;
@property (nonatomic, copy, readonly) ConfigureViewBlock configureCellBlock;

- (instancetype)initWithViewModel:(id <CADEMViewModelCollectionDelegate>)viewModel
               configureCellBlock:(ConfigureViewBlock)configureBlock;

- (instancetype)initWithViewModel:(id<CADEMViewModelCollectionDelegate>)viewModel
               configureCellBlock:(ConfigureViewBlock)configureBlock
             configureHeaderBlock:(ConfigureViewBlock)configureHeaderBlock;

@end
