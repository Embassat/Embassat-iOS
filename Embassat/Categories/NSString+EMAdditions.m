//
//  NSString+EMAdditions.m
//  Embassat
//
//  Created by Joan Romano on 27/03/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "NSString+EMAdditions.h"

@implementation NSString (EMAdditions)

- (NSString*)stringByRemovingTags
{
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:kNilOptions error:nil];
    });
    
    // Use reverse enumerator to delete characters without affecting indexes
    NSArray *matches =[regex matchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    NSEnumerator *enumerator = matches.reverseObjectEnumerator;
    
    NSTextCheckingResult *match = nil;
    NSMutableString *modifiedString = self.mutableCopy;
    while ((match = [enumerator nextObject]))
    {
        [modifiedString deleteCharactersInRange:match.range];
    }
    return modifiedString;
}

@end
