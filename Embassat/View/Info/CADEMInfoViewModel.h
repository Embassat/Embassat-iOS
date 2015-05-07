//
//  CADEMInfoViewModel.h
//  Embassat
//
//  Created by Joan Romano on 30/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "RVMViewModel.h"

#import "CADEMViewModelCollectionDelegate.h"

@interface CADEMInfoViewModel : RVMViewModel <CADEMViewModelCollectionDelegate>

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)bodyAtIndexPath:(NSIndexPath *)indexPath;

@end
