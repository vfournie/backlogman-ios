//
//  BKGCredentialStore.h
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BKGNotificationAuthTokenChanged;
extern NSString * const BKGNotificationUsernameChanged;

@interface BKGCredentialStore : NSObject

+ (instancetype)sharedStore;

- (void)clearCredentials;

- (NSString *)authToken;
- (void)setAuthToken:(NSString *)authToken;

- (NSString *)username;
- (void)setUsername:(NSString *)username;

@end
