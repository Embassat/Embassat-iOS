//
//  CADEMMapViewModel.h
//  Embassat
//
//  Created by Joan Romano on 14/04/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "RVMViewModel.h"

@interface CADEMMapViewModel : RVMViewModel

- (NSInteger)nunmberOfPoints;
- (double)latitudeForPointAtIndex:(NSInteger)index;
- (double)longitudeForPointAtIndex:(NSInteger)index;
- (NSString *)titleForPointAtIndex:(NSInteger)index;

@end
