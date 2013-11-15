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
             @"objectId": @"id",
             @"url" : @"url"
            };
}
    
@end
