//
//  CADEMMapViewModel.m
//  Embassat
//
//  Created by Joan Romano on 14/04/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMapViewModel.h"

@implementation CADEMMapViewModel

#pragma mark - Public

- (NSInteger)nunmberOfPoints
{
    return 3;
}

- (double)latitudeForPointAtIndex:(NSInteger)index
{
    static NSDictionary *mapping = nil;
    if(!mapping)
    {
        mapping = @{
                    @(0) : @(41.546838),
                    @(1) : @(41.547213),
                    @(2) : @(41.545738)
                    };
    }
    
    return [mapping[@(index)] doubleValue] ?: 0.0;
}

- (double)longitudeForPointAtIndex:(NSInteger)index
{
    static NSDictionary *mapping = nil;
    if(!mapping)
    {
        mapping = @{
                    @(0) : @(2.106158),
                    @(1) : @(2.106564),
                    @(2) : @(2.106824)
                    };
    }
    
    return [mapping[@(index)] doubleValue] ?: 0.0;
}

- (NSString *)titleForPointAtIndex:(NSInteger)index
{
    static NSDictionary *mapping = nil;
    if(!mapping)
    {
        mapping = @{
                    @(0) : @"Escenari Principal",
                    @(1) : @"Amfiteatre",
                    @(2) : @"Mirador Museu del Gas"
                    };
    }
    
    return mapping[@(index)] ?: @"";
}

@end
