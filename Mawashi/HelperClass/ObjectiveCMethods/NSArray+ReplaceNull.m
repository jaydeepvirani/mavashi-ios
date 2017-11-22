//
//  NSArray+ReplaceNull.m
//  MakeUpArtist
//
//  Created by Ashesh Shah on 24/10/13.
//  Copyright (c) 2013 Ashesh Shah. All rights reserved.
//

#import "NSArray+ReplaceNull.h"
#import "NSDictionary+NullReplacement.h"

//@implementation NSArrayAndReplaceNull
@implementation NSArray (ReplaceNull)

- (NSMutableArray *)arrayByReplacingNullsWithBlanks
{
    NSMutableArray *replaced = [self mutableCopy];
    
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (int idx = 0; idx < [replaced count]; idx++)
    {
        id object = [replaced objectAtIndex:idx];
        
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
    }
    return [replaced copy];
}
@end
