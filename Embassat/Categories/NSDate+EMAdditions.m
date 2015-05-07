//
//  NSDate+EMAdditions.m
//  Embassa't
//
//  Created by Joan Romano on 24/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "NSDate+EMAdditions.h"

@implementation NSDate (EMAdditions)

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

@end
