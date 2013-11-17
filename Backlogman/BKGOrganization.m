//
//  BKGOrganization.m
//  Backlogman
//
//  Created by Vincent Fournié on 14.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGOrganization.h"
#import "BKGProject.h"
#import "BKGBacklog.h"

@implementation BKGOrganization

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
             @"webSite" : @"web_site"
            }];
}

+ (NSValueTransformer *)projectsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:BKGProject.class];
}

+ (NSValueTransformer *)backlogsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:BKGBacklog.class];
}

@end
