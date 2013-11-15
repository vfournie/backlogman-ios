//
//  BKGAuthToken.h
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKGAuthToken : NSObject

@property (nonatomic, readonly, copy) NSString *token;

- (instancetype)initWithToken:(NSString *)token;

- (NSString *)asAuthenticationHeader;

@end
