//
//  BKGStory.h
//  Backlogman
//
//  Created by Vincent Fournié on 17.11.2013.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGObject.h"

@interface BKGStory : BKGObject

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *projectId;
@property (nonatomic, copy, readonly) NSString *backlogId;

@property (nonatomic, copy, readonly) NSString *textAsA;
@property (nonatomic, copy, readonly) NSString *textIWantTo;
@property (nonatomic, copy, readonly) NSString *textSoICan;

@property (nonatomic, copy, readonly) NSString *color;
@property (nonatomic, copy, readonly) NSString *comments;
@property (nonatomic, copy, readonly) NSString *acceptances;
@property (nonatomic, copy, readonly) NSString *theme;
@property (nonatomic, copy, readonly) NSString *status;

@end
