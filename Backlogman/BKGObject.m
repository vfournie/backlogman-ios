//
//  BKGObject.m
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGObject.h"

@implementation BKGObject

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"objectId": @"id"
            };
}

+ (NSValueTransformer *)idJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^(NSNumber *num) {
                return num.stringValue;
            }
            reverseBlock:^ id (NSString *str) {
                if (str == nil) {
                    return nil;
                }
                return [NSDecimalNumber decimalNumberWithString:str];
            }];
}

+ (NSValueTransformer *)objectIdJSONTransformer
{
    return [self idJSONTransformer];
}

+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
