//
//  CADEMMenuViewModel.m
//  Embassat
//
//  Created by Joan Romano on 22/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMenuViewModel.h"

@interface CADEMMenuViewModel ()

@property (nonatomic, strong) id model;

@end

@implementation CADEMMenuViewModel

#pragma mark Lifecycle

- (instancetype)init
{
	return [self initWithModel:nil];
}

- (instancetype)initWithModel:(id)model
{
	if (self = [super init])
    {
        _model = model;
    }
    
	return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.model count];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model[indexPath.row];
}

@end
