//
//  CADEMArtist.h
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADBaseModel.h"

@interface CADEMArtist : CADBaseModel

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *longDescription;
@property (nonatomic, copy, readonly) NSString *stage;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSURL *artistURL;
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) NSString *initialHour;
@property (nonatomic, copy, readonly) NSString *initialMinute;
@property (nonatomic, copy, readonly) NSString *finalHour;
@property (nonatomic, copy, readonly) NSString *finalMinute;

@property (nonatomic, strong, readonly) NSDate *initialDate;
@property (nonatomic, strong, readonly) NSDate *finalDate;

@end
