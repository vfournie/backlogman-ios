//
//  BKGAPIClient.h
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@class BKGAuthToken;


// The domain for all errors originating in BKGAPIClient.
extern NSString * const BKGAPIClientErrorDomain;

// JSON parsing failed, or a model object could not be created from the parsed
// JSON.
extern const NSInteger BKGAPIClientErrorJSONParsingFailed;


typedef void(^BKGError)(NSError *error);
typedef void(^BKGSignInSuccess)(BKGAuthToken *token);
typedef void(^BKGArraySuccess)(NSArray *list);

// Represents a Backlogman session.
//
@interface BKGAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (BOOL)isLoggedIn;

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(BKGSignInSuccess)success
                   failure:(BKGError)failure;

- (void)getProjectsWithSuccess:(BKGArraySuccess)success
                       failure:(BKGError)failure;

- (void)getOrganizationsWithSuccess:(BKGArraySuccess)success
                            failure:(BKGError)failure;

@end
