//
//  BKGProject.m
//  Backlogman
//
//  Created by Vincent Fournié on 14.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGProject.h"
#import "BKGBacklog.h"
#import "BKGStat.h"

@implementation BKGProject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"organizationId" : @"organization_id",
            @"themes" : @"available_themes"
           }];
}

+ (NSValueTransformer *)organizationIdJSONTransformer
{
    return [self idJSONTransformer];
}

+ (NSValueTransformer *)statsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:BKGStat.class];
}

+ (NSValueTransformer *)backlogsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:BKGBacklog.class];
}

@end
