//
//  BKGProject.m
//  Backlogman
//
//  Created by Vincent Fournié on 14.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGProject.h"

@implementation BKGProject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"name" : @"name",
            @"description" : @"description",
            @"code" : @"code"
           }];
}

@end
