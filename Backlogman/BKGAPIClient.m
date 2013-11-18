//
//  BKGAPIClient.m
//  Backlogman
//
//  Created by Vincent Fournié on 13.11.13.
//  Copyright (c) 2013 VFE. All rights reserved.
//

#import "BKGAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "BKGCredentialStore.h"
#import "BKGAuthToken.h"
#import "BKGModel.h"

NSString * const BKGAPIClientErrorDomain = @"BKGAPIClientErrorDomain";
const NSInteger BKGAPIClientErrorEmptyUsernameOrPassword = 601;
const NSInteger BKGAPIClientErrorEmptyToken = 602;
const NSInteger BKGAPIClientErrorJSONParsingFailed = 603;

static NSString * const BKGAPIClientAPIBaseURLString = @"https://app.backlogman.com/api";

@implementation BKGAPIClient

+ (instancetype)sharedClient
{
    static BKGAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BKGAPIClientAPIBaseURLString]];
//        [sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });

    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer new];
        self.responseSerializer = [AFJSONResponseSerializer new];

        [self setAuthorizationHeader];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:BKGNotificationAuthTokenChanged
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BKGNotificationAuthTokenChanged
                                                  object:nil];
}

- (BOOL)isLoggedIn
{
    NSString *token = [[BKGCredentialStore sharedStore] authToken];
    return (token != nil);
}

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(BKGSignInSuccess)success
                   failure:(BKGError)failure
{
    if ([username length] <= 0 || [password length] <= 0) {
        NSError *error = [self errorWithCode:BKGAPIClientErrorEmptyUsernameOrPassword
                               failureReason:NSLocalizedString(@"Empty username or password", nil)];
        failure(error);
        return;
    }

    [self POST:@"/api/api-token-auth/" parameters:@{ @"username" : username, @"password" : password }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *token = [responseObject objectForKey:@"token"];
           if (token) {
               [[BKGCredentialStore sharedStore] setAuthToken:token];
               [[BKGCredentialStore sharedStore] setUsername:username];

               BKGAuthToken *authToken = [[BKGAuthToken alloc] initWithToken:token];

               success(authToken);
           }
           else {
               NSError *error = [self errorWithCode:BKGAPIClientErrorEmptyToken
                                      failureReason:NSLocalizedString(@"Empty token", nil)];
               failure(error);
           }
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           failure(error);
       }];
}

- (void)getOrganizationsWithSuccess:(BKGArraySuccess)success
                            failure:(BKGError)failure
{
    [self getListForPath:@"/api/organizations/"
             resultClass:[BKGOrganization class]
                 success:success
                 failure:failure];
}

- (void)getStandaloneProjectsWithSuccess:(BKGArraySuccess)success
                                 failure:(BKGError)failure
{
    [self getListForPath:@"/api/projects/"
             resultClass:[BKGProject class]
                 success:^(NSArray *list) {
                     NSMutableArray *standAloneProjects = [NSMutableArray new];
                     for (BKGProject *project in list) {
                         if (project.organizationId == nil) {
                             [standAloneProjects addObject:project];
                         }
                     }
                     success(standAloneProjects);
                 }
                 failure:failure];
}

- (void)getProjectsForOrganizationId:(NSString *)orgId
                             success:(BKGArraySuccess)success
                                 failure:(BKGError)failure
{
    [self getListForPath:@"/api/projects/"
             resultClass:[BKGProject class]
                 success:success
                 failure:failure];
}

- (void)getStoriesForBacklogId:(NSString *)backlogId
                       success:(BKGArraySuccess)success
                       failure:(BKGError)failure
{
    [self getListForPath:[NSString stringWithFormat:@"/api/backlogs/%@/stories/", backlogId]
               resultClass:[BKGStory class]
                   success:success
                   failure:failure];
}

- (void)getOrganizationForId:(NSString *)organizationId
                     success:(BKGObjectSuccess)success
                     failure:(BKGError)failure
{
    [self getObjectForPath:[NSString stringWithFormat:@"/api/organizations/%@/", organizationId]
               resultClass:[BKGStory class]
                   success:success
                   failure:failure];
}

- (void)getProjectForId:(NSString *)projectId
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure
{
    [self getObjectForPath:[NSString stringWithFormat:@"/api/projects/%@/", projectId]
               resultClass:[BKGStory class]
                   success:success
                   failure:failure];
}

- (void)getBacklogForId:(NSString *)backlogId
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure
{
    [self getObjectForPath:[NSString stringWithFormat:@"/api/backlogs/%@/", backlogId]
               resultClass:[BKGStory class]
                   success:success
                   failure:failure];
}

- (void)getStoryForId:(NSString *)storyId
            backLogId:(NSString *)backlogId
              success:(BKGObjectSuccess)success
              failure:(BKGError)failure
{
    [self getObjectForPath:[NSString stringWithFormat:@"/api/backlogs/%@/stories/%@", backlogId, storyId]
               resultClass:[BKGStory class]
                   success:success
                   failure:failure];
}

- (void)getObjectDetail:(BKGObject *)object
                success:(BKGObjectSuccess)success
                failure:(BKGError)failure
{
    NSString *objectUrl = [object.url absoluteString];
    [self getObjectForPath:objectUrl
               resultClass:[object class]
                   success:success
                   failure:failure];
}

#pragma mark - Notifications

- (void)tokenChanged:(NSNotification *)notification
{
    [self setAuthorizationHeader];
}

#pragma mark - Private methods

- (void)getObjectForPath:(NSString *)path
             resultClass:(Class)resultClass
                 success:(BKGObjectSuccess)success
                 failure:(BKGError)failure
{
    [self GET:path parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *error;
          id parsedObject = [self parseResponseOfClass:resultClass
                                              fromJSON:responseObject
                                                 error:&error];
          if (error) {
              failure(error);
          }
          else {
              success(parsedObject);
          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          failure(error);
      }];
}

- (void)getListForPath:(NSString *)path
           resultClass:(Class)resultClass
               success:(BKGArraySuccess)success
               failure:(BKGError)failure
{
    [self GET:path parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *error;
          id parsedObject = [self parseResponseOfClass:resultClass
                                              fromJSON:responseObject
                                                 error:&error];
          if (error) {
              failure(error);
          }
          else {
              success(parsedObject);
          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          failure(error);
      }];
}

#pragma mark - Authorization header

- (void)setAuthorizationHeader
{
    NSString *token = [[BKGCredentialStore sharedStore] authToken];
    BKGAuthToken *authToken;
    if (token) {
        authToken = [[BKGAuthToken alloc] initWithToken:token];
    }
    [self setAuthorizationHeaderWithToken:authToken];
}

- (void)setAuthorizationHeaderWithToken:(BKGAuthToken *)token
{
    if (token) {
        [self.requestSerializer setValue:[token asAuthenticationHeader]
                      forHTTPHeaderField:@"Authorization"];
    }
    else {
        [self.requestSerializer clearAuthorizationHeader];
    }
}

#pragma mark - JSON parsing

- (id)parseResponseOfClass:(Class)resultClass fromJSON:(id)responseObject error:(NSError **)error
{
	NSParameterAssert(resultClass == nil || [resultClass isSubclassOfClass:MTLModel.class]);

    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *parsedResult = [NSMutableArray new];

        for (NSDictionary *dict in responseObject) {
            if (![dict isKindOfClass:[NSDictionary class]]) {
                NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), dict];
                if (error) {
                    *error = [self parsingErrorWithFailureReason:failureReason];
                }
                return nil;
            }

            BKGObject *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:dict error:error];
            if (parsedObject == nil) {
                return nil;
            }

            NSAssert([parsedObject isKindOfClass:BKGObject.class], @"Parsed model object is not an BKGObject: %@", parsedObject);
            [parsedResult addObject:parsedObject];
        }

        return parsedResult;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        BKGObject *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:responseObject error:error];
        if (parsedObject == nil) {
            return nil;
        }

        NSAssert([parsedObject isKindOfClass:[BKGObject class]], @"Parsed model object is not an BKGObject: %@", parsedObject);

        return parsedObject;
    }
    else {
        if (error) {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""),
                                       [responseObject class],
                                       responseObject];
            *error = [self parsingErrorWithFailureReason:failureReason];
        }
        return nil;
    }
}

#pragma mark - Error handling

- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");

	if (localizedFailureReason) {
		userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
	}

	return [NSError errorWithDomain:BKGAPIClientErrorDomain code:BKGAPIClientErrorJSONParsingFailed userInfo:userInfo];
}

- (NSError *)errorWithCode:(NSInteger)errorCode failureReason:(NSString *)localizedFailureReason
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (localizedFailureReason) {
		userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
    }
	return [NSError errorWithDomain:BKGAPIClientErrorDomain code:errorCode userInfo:userInfo];
}

@end
