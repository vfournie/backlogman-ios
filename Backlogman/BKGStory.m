//
//  BKGStory.m
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGStory.h"

@implementation BKGStory

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
             @"organizationId" : @"organization_id",
             @"projectId" : @"project_id",
             @"textAsA" : @"as_a",
             @"textIWantTo" : @"i_want_to",
             @"textSoICan" : @"so_i_can"
            }];
}

+ (NSValueTransformer *)organizationIdJSONTransformer
{
    return [self idJSONTransformer];
}

+ (NSValueTransformer *)projectIdJSONTransformer
{
    return [self idJSONTransformer];
}

@end
