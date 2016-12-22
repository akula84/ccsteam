//
//  API+ReplyHandling.m
//  Sample
//
//  Created by Alexander Kozin on 04.07.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "API_Protected.h"

#import <isFull.h>
#import "RCSignInAPI.h"
#import "AppState.h"
#import "AppDelegate.h"

@implementation API (ReplyHandling)

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    if (self.shouldLogRequest) {
        NSLog(@"#Request %@ DONE: %@ Reply: %@", [self method], self.sessionTask.currentRequest.URL, reply);
    }

    [self setLastReply:reply];
    [self setLastError:nil];

    if (self.completion) {
        self.completion(reply, nil, NULL);
    }
    [self apiDidEnd];
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:NO];
}

- (void)apiDidFailWithError:(NSError*)error
{
    NSURLSessionDataTask *sessionTask = self.sessionTask;
    if (self.shouldLogRequest) {
        NSLog(@"#Request %@ FAIL: %@ with EROR: %@", [self method], sessionTask.currentRequest.URL, error);
    }
    [self setLastReply:nil];
    [self setLastError:error];

    BOOL shouldUseDefaultErrorHandler = YES;

    if (self.completion) {
        self.completion(nil, error, &shouldUseDefaultErrorHandler);
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)sessionTask.response;
    if (response.statusCode == 401) {
        [self reAuthorizeUser];
    } else {
        if (shouldUseDefaultErrorHandler) {
            [self showError:error];
        }
    }
    [self apiDidEnd];
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:NO];
}

- (void)reAuthorizeUser
{
    AppState *state = [AppState sharedInstance];
    NSString *login = state.user.login;
    NSString *savedUserPassword = [AppState savedUserPassword];
    if (!login) {return;}
    if (!savedUserPassword) {return;}
    NSDictionary *object =@{kLogin:login,
                            kPassword:savedUserPassword};
   [RCSignInAPI withObject:object completion:^(id reply, NSError *error, BOOL *handleError) {
        if (!error) {
            [self sendRequest];
        }
    }];
}

- (void)showError:(NSError *)error
{
    
}

- (void)apiDidEnd
{
    [self setSessionTask:nil];
}

- (NSError *)apiErrorFromNetworkError:(NSError *)networkError
{
    NSError *apiError;

    NSDictionary *userInfo = networkError.userInfo;
    NSString *suggestionString = userInfo[@"NSLocalizedRecoverySuggestion"];
    NSDictionary *suggestion = nil;
    if ([suggestionString isFull]) {
        suggestion = [NSJSONSerialization JSONObjectWithData:[suggestionString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:(NSJSONReadingOptions)0
                                                       error:nil];
    }

    if ([suggestion isFull]) {
        NSDictionary *error = suggestion[@"error"];

        NSInteger code = 0;
        id codeNumber = error[@"code"];
        if ([codeNumber isFull]) {
            code = [codeNumber integerValue];
        }

        apiError = [NSError errorWithDomain:networkError.domain
                                       code:code
                                   userInfo:userInfo];
    } else {
        apiError = networkError;
    }
    
    return apiError;
}

@end
