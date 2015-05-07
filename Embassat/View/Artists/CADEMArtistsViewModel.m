//
//  CADEMArtistsViewModel.m
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMArtistsViewModel.h"

#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

#import "CADEMArtist.h"
#import "CADEMArtistDetailViewModel.h"

static NSString *const kArtistsCacheKey = @"ArtistsCacheKey";
static NSString *const kArtistsResource = @"get_posts/?post_type=artista&count=100";

@interface CADEMArtistsViewModel ()

@property (nonatomic, strong) id model;

@end

@implementation CADEMArtistsViewModel

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
        
        RAC(self, model) = [self.didBecomeActiveSignal
                             flattenMap:^RACStream *(id value) {
                                 return [self artists];
                             }];
    }
    
	return self;
}

#pragma mark - Public

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.model count];
}

- (id)artistViewModelForIndexPath:(NSIndexPath *)indexPath
{
    return [[CADEMArtistDetailViewModel alloc] initWithModel:self.model[indexPath.row]];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    return [[(CADEMArtist *)self.model[indexPath.row] name] uppercaseString];
}

#pragma mark - Private

- (id)model
{
    return [_model sortedArrayUsingComparator:^NSComparisonResult(CADEMArtist *artist1, CADEMArtist *artist2) {
        return [artist1.name caseInsensitiveCompare:artist2.name];
    }];
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
