//
//  NSDate+EMAdditions.m
//  Embassa't
//
//  Created by Joan Romano on 24/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "NSDate+EMAdditions.h"

// Thanks, AshFurrow
static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

@implementation NSDate (EMAdditions)

// Courtesy of Lukasz Margielewski
+ (NSCalendar *)currentCalendar
{
    static dispatch_once_t pred;
    static __strong NSCalendar *sharedCalendar = nil;
    
    dispatch_once(&pred, ^{
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    
    return sharedCalendar;
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

- (NSInteger)hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    
    return components.hour;
}

- (NSInteger)minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    
    return components.minute;
}

@end
