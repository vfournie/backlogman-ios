//
//  BKGOrganization.h
//  Backlogman
//
//  Created by Vincent Fournié on 14.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKGObject.h"

@interface BKGOrganization : BKGObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *webSite;
@property (nonatomic, copy) NSArray *projects;
@property (nonatomic, copy) NSArray *backlogs;

@end
