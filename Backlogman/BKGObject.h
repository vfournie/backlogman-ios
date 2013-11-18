//
//  BKGObject.h
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "BKGEntity.h"

@interface BKGObject : BKGEntity <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *objectId;
@property (nonatomic, copy, readonly) NSURL *url;

+ (NSValueTransformer *)idJSONTransformer;

@end
