//
//  CADEMArtistDetailViewModel.h
//  Embassat
//
//  Created by Joan Romano on 26/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "RVMViewModel.h"

@class CADEMArtist;

@interface CADEMArtistDetailViewModel : RVMViewModel

// The model which the view model is adapting for the UI.
@property (nonatomic, readonly, strong) CADEMArtist *model;

@property (nonatomic, copy, readonly) NSString *artistName, *artistDescription, *artistStartHour, *artistStartMinute, *artistDay, *artistStage;
@property (nonatomic, strong, readonly) NSURL *artistImageURL;

// Creates a new view model with the given model.
//
// model - The model to adapt for the UI. This argument may be nil.
//
// Returns an initialized view model, or nil if an error occurs.
- (instancetype)initWithModel:(id)model;

- (void)addEventOnCalendar;

@end
