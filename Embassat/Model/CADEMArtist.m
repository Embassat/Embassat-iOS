//
//  CADEMArtist.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMArtist.h"

@interface CADEMArtist ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic, strong) NSDate *finalDate;

@end

@implementation CADEMArtist

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"title",
             @"longDescription" : @"content",
             @"stage" : @"custom_fields.escenari",
             @"date" : @"custom_fields.data",
             @"artistURL" : @"url",
             @"imageURL" : @"thumbnail_images.medium.url",
             @"initialHour" : @"custom_fields.hora_inici",
             @"initialMinute" : @"custom_fields.minut_inici",
             @"finalHour" : @"custom_fields.hora_final",
             @"finalMinute" : @"custom_fields.minut_final"
             };
}

+ (NSValueTransformer *)artistURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)initialHourJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

+ (NSValueTransformer *)finalHourJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

+ (NSValueTransformer *)stageJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

+ (NSValueTransformer *)initialMinuteJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

+ (NSValueTransformer *)finalMinuteJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^(NSArray *array) {
        return [array firstObject];
    }];
}

#pragma mark - Lazy

- (NSDate *)initialDate
{
    return [self realDateWithHour:self.initialHour minute:self.initialMinute];
}

- (NSDate *)finalDate
{
    return [self realDateWithHour:self.finalHour minute:self.finalMinute];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    }
    
    return _dateFormatter;
}

#pragma mark - Private

- (NSDate *)realDateWithHour:(NSString *)hour minute:(NSString *)minute
{
    NSDate *resultDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@:%@", self.date, hour, minute]];
    
    if ([[hour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
    {
        NSDateComponents *compontents = [[NSDateComponents alloc] init];
        compontents.day = 1;
        resultDate = [[NSCalendar currentCalendar] dateByAddingComponents:compontents toDate:resultDate options:0];
    }
    
    return resultDate;
}

@end
