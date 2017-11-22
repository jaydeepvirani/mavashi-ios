//
//  NSDictionary+NullReplacement.m
//  MakeUpArtist
//
//  Created by Ashesh Shah on 24/10/13.
//  Copyright (c) 2013 Ashesh Shah. All rights reserved.
//

#import "NSDictionary+NullReplacement.h"
#import "NSArray+ReplaceNull.h"
#import "ObjectiveCMethods.h"

@implementation NSDictionary (NullReplacement)

- (NSMutableDictionary *)dictionaryByReplacingNullsWithBlanks
{
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self)
    {
        id object = [self objectForKey:key];
        
        if(object == nul)
        {
            if ([key isEqualToString:@"price"]) {
                [replaced setObject:@"0" forKey:key];
            }else{
                [replaced setObject:blank forKey:key];
            }
        }
        else if (([object isKindOfClass:[NSString class]]))
        {
            NSString *tempString = [object stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            tempString = [tempString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
            // tempString=[tempString stringByReplacingOccurrencesOfString:@"\" withString:@"&quot;"];@"<br>"
            tempString=[tempString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            [replaced setObject:tempString forKey:key];
            
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            [replaced setObject:[ObjectiveCMethods arrayByReplacingNullsWithBlanks: object] forKey:key];
        }
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:[replaced copy]];
}


/*NSString *tempString = [textPost.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
 tempString = [tempString stringByReplacingOccurrencesOfString:@"\'" withString:@"&#39;"];
 tempString=[tempString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
 tempString=[tempString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];*/


- (NSMutableDictionary *)Replacespecialcharacter
{
    const NSMutableDictionary *replaced = [self mutableCopy];
    
    for (NSString *key in self)
    {
        id object = [self objectForKey:key];
        
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *tempString = [object stringByReplacingOccurrencesOfString:@"\'" withString:@"&#39;"];
            
            // tempString=[tempString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
            
            tempString=[tempString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            [replaced setObject:tempString forKey:key];
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        }
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:[replaced copy]];
}


@end
