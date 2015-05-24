//
//  CADEMScheduleViewModel.m
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMScheduleViewModel.h"

#import "UIColor+EMAdditions.h"
#import "NSDate+EMAdditions.h"

@interface CADEMScheduleViewModel ()

@property (nonatomic, strong) id model;

@end

@implementation CADEMScheduleViewModel

#pragma mark - Lifecycle

- (instancetype)init
{
	return [self initWithModel:nil];
}

- (instancetype)initWithModel:(id)model
{
	if (self = [super init])
    {
        _model = model;
        
        _updatedContentSignal = [RACObserve(self, model) ignore:nil];
        
        RAC(self, model) = [[self.didBecomeActiveSignal
                            flattenMap:^RACStream *(id value) {
                                return [[[CADEMArtistService alloc] init] artists];
                            }] map:^id(id value) {
                                return @[value,
                                         value,
                                         value];
                            }];
    }
    
	return self;
}

#pragma mark - Public

- (void)setDayIndex:(NSInteger)dayIndex
{
    if (dayIndex > 2 || dayIndex < 0)
        return;
    
    _dayIndex = dayIndex;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.model[self.dayIndex] count];
}

- (NSString *)artistNameAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].name;
}

- (NSString *)stageNameAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].stage;
}

- (NSString *)initialMinuteAtIndexPath:(NSIndexPath *)indexPath
{
    return [@([self artistAtIndexPath:indexPath].date.minute) stringValue];
}

- (NSString *)initialHourAtIndexPath:(NSIndexPath *)indexPath
{
    return [@([self artistAtIndexPath:indexPath].date.hour) stringValue];
}

- (NSString *)finalMinuteAtIndexPath:(NSIndexPath *)indexPath
{
    return [@([self artistAtIndexPath:indexPath].date.minute) stringValue];
}

- (NSString *)finalHourAtIndexPath:(NSIndexPath *)indexPath
{
    return [@([self artistAtIndexPath:indexPath].date.hour) stringValue];
}

- (BOOL)favoritedStatusAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].favorite;
}

- (id)artistViewModelForIndexPath:(NSIndexPath *)indexPath
{
    return [[CADEMArtistDetailViewModel alloc] initWithModel:self.model[self.dayIndex] currentIndex:indexPath.item];
}

- (UIColor *)colorAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDictionary *mapping = nil;
    if(!mapping)
    {
        mapping = @{
                    @"Amfiteatre Yeearphone" : [UIColor em_stageRedColor],
                    @"Escenari Gran" : [UIColor em_stageYellowColor],
                    @"Mirador" : [UIColor em_stageBlueColor],
                    };
    }
    
    return mapping[[self stageNameAtIndexPath:indexPath]] ?: [UIColor whiteColor];
}

- (UIColor *)backgroundColorAtIndexPath:(NSIndexPath *)indexPath
{
    CADEMArtistSwift *artist = [self artistAtIndexPath:indexPath];
    NSDate * now = [NSDate date];
    
    return [now isLaterThanDate:artist.date] && [now isEarlierThanDate:artist.date] ?
        [UIColor em_backgroundColor] : [UIColor em_backgroundDeselectedColor];
}

#pragma mark - Private

- (NSArray *)filteredArrayFromArray:(NSArray *)array withDateString:(NSString *)dateString
{
    return [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date == %@", dateString]] sortedArrayUsingComparator:^NSComparisonResult(CADEMArtistSwift *artist1, CADEMArtistSwift *artist2) {
        return [artist1.date isEarlierThanDate:artist2.date];
    }];
}

//- (NSArray *)filteredFixingHoursArrayFromArray:(NSArray *)array
//{
//    return [[[array rac_sequence] filter:^BOOL(CADEMArtistSwift *artist) {
//        return ![[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
//    }] concat:[[array rac_sequence] filter:^BOOL(CADEMArtistSwift *artist) {
//        return [[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
//    }]].array;
//}

- (CADEMArtistSwift *)artistAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model[self.dayIndex][indexPath.item];
}

@end
