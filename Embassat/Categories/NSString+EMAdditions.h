//
//  NSString+EMAdditions.h
//  Embassat
//
//  Created by Joan Romano on 27/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EMAdditions)

- (NSString *)stringByRemovingTags;

- (NSString *)scanStringWithStartTag:(NSString *)startTag endTag:(NSString *)endTag;

@end
