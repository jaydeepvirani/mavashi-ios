//
//  ObjectiveCMethods.h
//  PTO
//
//  Created by fiplmac1 on 08/09/16.
//  Copyright © 2016 fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSDictionary+NullReplacement.h"

@interface ObjectiveCMethods : NSObject

+ (NSArray*)decodePolylineWithString:(NSString *)encodedString;

+(NSString *) findUniqueSavePath;
+(UIImage *)scaleAndRotateImage:(UIImage *)image;

+ (NSMutableArray *)arrayByReplacingNullsWithBlanks:(NSArray *)arrData;
+ (NSMutableDictionary *)dictionaryByReplacingNullsWithBlanks:(NSDictionary *)dictData;

@end
