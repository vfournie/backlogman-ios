//
//  BKGObject.h
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BKGObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *objectId;
@property (nonatomic, copy, readonly) NSURL *url;

@end
