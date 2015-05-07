//
//  CADEMViewModelCollectionDelegate.h
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

@protocol CADEMViewModelCollectionDelegate <NSObject>

@optional

- (NSInteger)numberOfSections;

@required

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

@end
