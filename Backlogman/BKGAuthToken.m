//
//  BKGAuthToken.m
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGAuthToken.h"

@implementation BKGAuthToken

- (instancetype)initWithToken:(NSString *)token
{
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (NSString *)asAuthenticationHeader
{
    if (self.token) {
        return [NSString stringWithFormat:@"Token %@", self.token];
    }
    return nil;
}

@end
