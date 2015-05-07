//
//  CADBaseModel.h
//  Embassat
//
//  Created by Joan Romano on 08/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "MTLModel.h"

#import <MTLModel.h>
#import <MTLJSONAdapter.h>
#import <MTLValueTransformer.h>
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@interface CADBaseModel : MTLModel <MTLJSONSerializing>

@end
