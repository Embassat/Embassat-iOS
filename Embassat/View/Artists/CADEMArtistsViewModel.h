//
//  CADEMArtistsViewModel.h
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "RVMViewModel.h"

#import "CADEMViewModelCollectionDelegate.h"

@interface CADEMArtistsViewModel : RVMViewModel <CADEMViewModelCollectionDelegate>

// The model which the view model is adapting for the UI.
@property (nonatomic, readonly, strong) id model;

@property (nonatomic, readonly) RACSignal *updatedContentSignal;

// Creates a new view model with the given model.
//
// model - The model to adapt for the UI. This argument may be nil.
//
// Returns an initialized view model, or nil if an error occurs.
- (instancetype)initWithModel:(id)model;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)artistViewModelForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;

@end
