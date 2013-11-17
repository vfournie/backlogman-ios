//
//  BKGStat.m
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGStat.h"

@implementation BKGStat

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"estimatedPoints": @"estimated_points",
             @"completedPoints": @"completed_points",
             @"percentEstimated": @"percent_estimated",
             @"percentCompleted": @"percent_completed",
             @"totalPtories": @"total_stories",
             @"totalPoints": @"total_points",
             @"completedStories": @"completed_stories",
             @"estimatedStories": @"estimated_stories",
            };
}

@end
