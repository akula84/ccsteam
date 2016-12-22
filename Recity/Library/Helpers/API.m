//
//  API.m
//
//  Created by Alexander Kozin on 1/13/13.
//  Copyright (c) 2013 Alexander Kozin. All rights reserved.
//

#import "API_Protected.h"

@import ObjectiveC.runtime;

@implementation API

+ (void)initialize
{
    if (self == [API class]) {
        [self createHttpClient];
    }
}

+ (void)createHttpClient
{
    AFHTTPSessionManager *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL]
                                                                sessionConfiguration:nil];

    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:(NSJSONWritingOptions)kNilOptions];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];

    [httpClient setRequestSerializer:requestSerializer];
    // Turn off any caching
    [httpClient setDataTaskWillCacheResponseBlock:nil];

    [[httpClient reachabilityManager] startMonitoring];

    objc_setAssociatedObject(self, @selector(httpClient), httpClient, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSCachedURLResponse *)willCacheURLResponse:(NSCachedURLResponse *)response
{
    return response;
}

+ (AFHTTPSessionManager*)httpClient
{
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSURL *)baseURL
{
    // This is a place to configure API base URL if depends on something
    // E.g. builds for different servers
    NSString *baseURLString = kAPIBaseURL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];

    return baseURL;
}

- (void)prepare
{
    // This is a place to set default settings to API objects
    // E.g. add access token to request or log level
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:YES];
    [self setShouldAddAccessToken:YES];
    [self setShouldLogRequest:NO];
}

+ (BOOL)networkIsReachable
{
    BOOL reachable;

    AFNetworkReachabilityStatus status = [[self.httpClient reachabilityManager] networkReachabilityStatus];
    reachable = status != AFNetworkReachabilityStatusNotReachable;

    return reachable;
}

- (void)invokeApiNotReachableSequence
{
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                         code:-1009
                                     userInfo:nil];

    [self apiDidFailWithError:error];
}

// Override this method to set REST method
- (NSString *)method
{
    AWAssertShouldOverrideReturnNil;
}

// Override this method to add some parameters to URL
- (NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    return parameters;
}

// Override this method to add some parameters to URL
- (NSDictionary *)bodyParameters
{
    NSDictionary *parameters = [NSDictionary dictionary];
    
    return parameters;
}

// Override this method to set request relative path
- (NSString *)path
{
    AWAssertShouldOverrideReturnNil;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, path:%@", [super description], self.path];
}

@end
