//
//  BKGBacklog.h
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGObject.h"
#import "BKGStat.h"

@interface BKGBacklog : BKGObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSString *organizationId;
@property (nonatomic, copy, readonly) NSString *projectId;
@property (nonatomic, assign) BOOL isMain;
@property (nonatomic, copy) NSArray *themes;
@property (nonatomic, strong, readonly) BKGStat *stats;

@end
