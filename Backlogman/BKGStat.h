//
//  BKGStat.h
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BKGStat : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger estimatedPoints;
@property (nonatomic, assign) NSInteger completedPoints;
@property (nonatomic, assign) CGFloat percentEstimated;
@property (nonatomic, assign) CGFloat percentCompleted;
@property (nonatomic, assign) NSInteger totalStories;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger completedStories;
@property (nonatomic, assign) NSInteger estimatedStories;

@end
