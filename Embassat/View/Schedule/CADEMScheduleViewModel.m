//
//  CADEMScheduleViewModel.m
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMScheduleViewModel.h"

#import "UIColor+EMAdditions.h"
#import "CADEMArtistDetailViewModel.h"
#import "NSDate+EMAdditions.h"

#import "CADEMArtist.h"

static NSString *const kArtistsCacheKey = @"ArtistsCacheKey";
static NSString *const kArtistsResource = @"get_posts/?post_type=artista&count=100";

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
                                return [self artists];
                            }] map:^id(id value) {
                                NSArray *firstDayByHoursOrderedArray = [self filteredArrayFromArray:value
                                                                                     withDateString:@"26/06/2014"],
                                        *secondDayByHoursOrderedArray = [self filteredArrayFromArray:value
                                                                                      withDateString:@"27/06/2014"],
                                        *thirdDayByHoursOrderedArray = [self filteredArrayFromArray:value
                                                                                     withDateString:@"28/06/2014"];
                                
                                return @[[self filteredFixingHoursArrayFromArray:firstDayByHoursOrderedArray],
                                         [self filteredFixingHoursArrayFromArray:secondDayByHoursOrderedArray],
                                         [self filteredFixingHoursArrayFromArray:thirdDayByHoursOrderedArray]];
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
    return [[self artistAtIndexPath:indexPath].name uppercaseString];
}

- (NSString *)stageNameAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].stage;
}

- (NSString *)initialMinuteAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].initialMinute;
}

- (NSString *)initialHourAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].initialHour;
}

- (NSString *)finalMinuteAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].finalMinute;
}

- (NSString *)finalHourAtIndexPath:(NSIndexPath *)indexPath
{
    return [self artistAtIndexPath:indexPath].finalHour;
}

- (id)artistViewModelForIndexPath:(NSIndexPath *)indexPath
{
    return [[CADEMArtistDetailViewModel alloc] initWithModel:self.model[self.dayIndex][indexPath.row]];
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
    CADEMArtist *artist = [self artistAtIndexPath:indexPath];
    NSDate * now = [NSDate date];
    static NSDictionary *mapping = nil;
    if(!mapping)
    {
        mapping = @{
                    @"Amfiteatre Yeearphone" : [UIColor em_stageRedBackgroundColor],
                    @"Escenari Gran" : [UIColor em_stageYellowBackgroundColor],
                    @"Mirador" : [UIColor em_stageBlueBackgroundColor],
                    };
    }
    
    return [now isLaterThanDate:artist.initialDate] && [now isEarlierThanDate:artist.finalDate] ?
        mapping[[self stageNameAtIndexPath:indexPath]] ?: [UIColor whiteColor] : [UIColor whiteColor];
}

#pragma mark - Private

- (NSArray *)filteredArrayFromArray:(NSArray *)array withDateString:(NSString *)dateString
{
    return [[array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"date == %@", dateString]] sortedArrayUsingComparator:^NSComparisonResult(CADEMArtist *artist1, CADEMArtist *artist2) {
        return [artist1.initialHour caseInsensitiveCompare:artist2.initialHour];
    }];
}

- (NSArray *)filteredFixingHoursArrayFromArray:(NSArray *)array
{
    return [[[array rac_sequence] filter:^BOOL(CADEMArtist *artist) {
        return ![[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
    }] concat:[[array rac_sequence] filter:^BOOL(CADEMArtist *artist) {
        return [[artist.initialHour substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
    }]].array;
}

- (CADEMArtist *)artistAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model[self.dayIndex][indexPath.row];
}

- (RACSignal *)artists
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [OBConnection makeRequest:[OBRequest requestWithType:OBRequestMethodTypeMethodGET resource:kArtistsResource parameters:[OBRequestParameters emptyRequestParameters]] withCacheKey:kArtistsCacheKey parseBlock:^id(NSDictionary *data) {
            return [[NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CADEMArtist.class] transformedValue:data[@"posts"]];
        } success:^(id data, BOOL cached) {
            [subscriber sendNext:data];
            cached ? : [subscriber sendCompleted];
        } error:^(id data, NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }] replayLazily];
}

@end
