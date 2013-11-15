//
//  BKGCredentialStore.m
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGCredentialStore.h"
#import <SSKeychain/SSKeychain.h>

NSString * const BKGNotificationAuthTokenChanged = @"BKGNotificationAuthTokenChanged";
NSString * const BKGNotificationUsernameChanged = @"BKGNotificationUsernameChanged";

static NSString * const BKGCredentialStoreServiceName = @"Backlogman";
static NSString * const BKGCredentialStoreAuthTokenKey = @"auth-token";
static NSString * const BKGCredentialStoreUsernameKey = @"username";

@interface BKGCredentialStore ()

@property (nonatomic, strong) dispatch_queue_t storeQueue;

@end

@implementation BKGCredentialStore

+ (instancetype)sharedStore
{
    static BKGCredentialStore *sharedStore = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });

    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
		_storeQueue = dispatch_queue_create("ch.vfe.backlogman.storeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)clearCredentials
{
    dispatch_async(self.storeQueue, ^{
        [self setAuthToken:nil];
        [self setUsername:nil];
    });
}

- (NSString *)authToken
{
    __block NSString *token;
    dispatch_sync(self.storeQueue, ^{
        token = [self secureValueForKey:BKGCredentialStoreAuthTokenKey];
    });
    return token;
}
- (void)setAuthToken:(NSString *)authToken
{
    dispatch_async(self.storeQueue, ^{
        [self setSecureValue:authToken forKey:BKGCredentialStoreAuthTokenKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BKGNotificationAuthTokenChanged
                                                                object:self];
        });
    });
}

- (NSString *)username
{
    __block NSString *username;
    dispatch_sync(self.storeQueue, ^{
        username = [self secureValueForKey:BKGCredentialStoreUsernameKey];
    });
    return username;
    
}
- (void)setUsername:(NSString *)username
{
    dispatch_async(self.storeQueue, ^{
        [self setSecureValue:username forKey:BKGCredentialStoreUsernameKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BKGNotificationUsernameChanged
                                                                object:self];
        });
    });
}

#pragma mark - Private methods

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key
{
    if (value) {
        [SSKeychain setPassword:value
                     forService:BKGCredentialStoreServiceName
                        account:key];
    }
    else {
        [SSKeychain deletePasswordForService:BKGCredentialStoreServiceName account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key
{
    return [SSKeychain passwordForService:BKGCredentialStoreServiceName account:key];
}

@end
