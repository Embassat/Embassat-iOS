//
//  NSDate+EMAdditions.h
//  Embassa't
//
//  Created by Joan Romano on 24/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

@interface NSDate (EMAdditions)

- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

@property (readonly) NSInteger day;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;

@property (readonly) NSString *hourString;
@property (readonly) NSString *minuteString;

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;

@end
