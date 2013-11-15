//
//  BKGOrganization.m
//  Backlogman
//
//  Created by Vincent Fournié on 14.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGOrganization.h"

@implementation BKGOrganization

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
             @"name" : @"name",
             @"description" : @"description",
             @"email" : @"email",
             @"webSite" : @"web_site"
            }];
}

@end
