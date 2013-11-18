//
//  BKGBacklog.m
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGBacklog.h"
#import "BKGStat.h"

@implementation BKGBacklog

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
             @"organizationId" : @"organization_id",
             @"projectId" : @"project_id",
             @"isMain" : @"is_main",
             @"themes" : @"available_themes"
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

+ (NSValueTransformer *)statsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:BKGStat.class];
}

@end
