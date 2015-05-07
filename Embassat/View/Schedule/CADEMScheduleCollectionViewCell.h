//
//  CADEMScheduleCollectionViewCell.h
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADRootCollectionViewCell.h"

@interface CADEMScheduleCollectionViewCell : CADRootCollectionViewCell

@property (nonatomic, copy) NSString *initialHour, *initialMinute;
@property (nonatomic, copy) NSString *finalHour, *finalMinute;
@property (nonatomic, copy) NSString *artistName, *stageName;

@property (nonatomic, strong) UIColor *leftColor;

@end
