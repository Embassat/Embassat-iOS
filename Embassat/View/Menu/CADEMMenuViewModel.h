//
//  CADEMMenuViewModel.h
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "RVMViewModel.h"

#import "CADEMViewModelCollectionDelegate.h"

@interface CADEMMenuViewModel : RVMViewModel <CADEMViewModelCollectionDelegate>

// Creates a new view model with the given model.
//
// model - The model to adapt for the UI. This argument may be nil.
//
// Returns an initialized view model, or nil if an error occurs.
- (instancetype)initWithModel:(id)model;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

@end
