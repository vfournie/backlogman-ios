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
@class BKGObject;

// The domain for all errors originating in BKGAPIClient.
extern NSString * const BKGAPIClientErrorDomain;

// JSON parsing failed, or a model object could not be created from the parsed
// JSON.
extern const NSInteger BKGAPIClientErrorJSONParsingFailed;

typedef void(^BKGError)(NSError *error);
typedef void(^BKGSignInSuccess)(BKGAuthToken *token);
typedef void(^BKGArraySuccess)(NSArray *list);
typedef void(^BKGObjectSuccess)(BKGObject *object);


// Represents a Backlogman session.
//
@interface BKGAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (BOOL)isLoggedIn;

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(BKGSignInSuccess)success
                   failure:(BKGError)failure;

- (void)getOrganizationsWithSuccess:(BKGArraySuccess)success
                            failure:(BKGError)failure;

- (void)getStandaloneProjectsWithSuccess:(BKGArraySuccess)success
                                 failure:(BKGError)failure;

- (void)getProjectsForOrganizationId:(NSString *)orgId
                             success:(BKGArraySuccess)success
                             failure:(BKGError)failure;

- (void)getStoriesForBacklogId:(NSString *)backlogId
                       success:(BKGArraySuccess)success
                       failure:(BKGError)failure;

- (void)getOrganizationForId:(NSString *)organizationId
                     success:(BKGObjectSuccess)success
                     failure:(BKGError)failure;

- (void)getProjectForId:(NSString *)projectId
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure;

- (void)getBacklogForId:(NSString *)backlogId
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure;

- (void)getStoryForId:(NSString *)storyId
            backLogId:(NSString *)backlogId
              success:(BKGObjectSuccess)success
              failure:(BKGError)failure;

- (void)getObjectDetail:(BKGObject *)object
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure;

@end
