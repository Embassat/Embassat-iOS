//
//  CADEMArtistDetailViewModel.m
//  Embassat
//
//  Created by Joan Romano on 26/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMArtistDetailViewModel.h"

#import "NSString+EMAdditions.h"
#import <EventKit/EventKit.h>

@interface CADEMArtistDetailViewModel ()

@property (nonatomic, strong) CADEMArtistSwift *model;

@end

@implementation CADEMArtistDetailViewModel

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
        
        RAC(self, artistName) = RACObserve(self.model, name);
        RAC(self, artistDescription) = [RACObserve(self.model, longDescription) map:^id(NSString *longDescription) {
            NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                       NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
            NSData *data = [longDescription dataUsingEncoding:NSUTF8StringEncoding];

            return [[[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil] string];
        }];
//        RAC(self, artistStage) = [RACObserve(self.model, stage) map:^id(NSString *stage) {
//            return [stage isEqualToString:@"Amfiteatre Yeearphone"] ? @"AMFITEATRE" : [stage uppercaseString];
//        }];
        RAC(self, artistImageURL) = RACObserve(self.model, imageURL);
//        RAC(self, artistStartHour) = RACObserve(self.model, initialHour);
//        RAC(self, artistStartMinute) = RACObserve(self.model, initialMinute);
//        RAC(self, artistDay) = [RACObserve(self.model, date) map:^id(NSString *dateString) {
//            return [dateString isEqualToString:@"25/06/2014"] ? @"DIM" : [dateString isEqualToString:@"26/06/2014"] ? @"DIJ" : [dateString isEqualToString:@"27/06/2014"] ? @"DIV" : @"DIS";
//        }];
    }
    
	return self;
}

#pragma mark - Public

- (void)addEventOnCalendar
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = [NSString stringWithFormat:@"%@ @ %@", self.artistName, self.artistStage];
//        event.startDate = self.model.initialDate;
//        event.endDate = self.model.finalDate;
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        BOOL success = [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        
        if (success)
        {
            DDLogInfo(@"Event added with id: %@", savedEventId);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Embassa't" message:@"Afegit al calenari correctament" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"D'acord", nil] show];
            });
        }
    }];
}

@end
