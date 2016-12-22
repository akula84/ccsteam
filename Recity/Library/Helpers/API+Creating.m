//
//  API+Creating.m
//  Sample
//
//  Created by Alexander Kozin on 04.07.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "API_Protected.h"

@implementation API (Creating)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

+ (instancetype)api
{
    id api = [self new];
    return api;
}

+ (instancetype)withObject:(id)object
{
    id api = [self api];
    [api setObject:object];
    
    return api;
}

+ (instancetype)withCompletion:(void (^)(id reply, NSError *error, BOOL *handleError))completion
{
    id api = [self api];
    [api sendRequestWithCompletion:completion];

    return api;
}

+ (instancetype)withObject:(id)object completion:(void (^)(id reply, NSError *error, BOOL *handleError))completion
{
    id api = [self withObject:object];
    [api sendRequestWithCompletion:completion];

    return api;
}

- (NSMutableURLRequest *)createRequest
{
    NSMutableURLRequest *request;

    NSString *method = [self method];
    NSString *path = [[self path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [self parameters];
    // Prevent appending empty parameters
    if (![parameters isFull]) {
        parameters = nil;
    }else {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
        param[@"appid"] = token;
        parameters = [NSDictionary dictionaryWithDictionary:param];
    }
    
    request = [self requestWithMethod:method
                                 path:path
                           parameters:parameters];
    NSString *bodyParameters = [self bodyParameters];
    if ([bodyParameters isFull]) {
        NSData *httpBodyData = [bodyParameters dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:httpBodyData];
    }
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request;

    AFHTTPSessionManager *httpClient = [API httpClient];
    AFHTTPRequestSerializer *serializer = [self serializer:httpClient];//[httpClient requestSerializer];

    NSURL *url = [NSURL URLWithString:path relativeToURL:httpClient.baseURL];

    NSError *serializationError = nil;
    
    if (self.files) {
        request = [serializer multipartFormRequestWithMethod:method
                                                   URLString:[url absoluteString]
                                                  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                      for (FileModel *file in self.files) {
                                                          [formData appendPartWithFileData: file.data name:file.name fileName:file.fileName mimeType:file.type];
                                                      }
                                                  } error:&serializationError
        ];
    } else {
        request = [serializer requestWithMethod:method
                                      URLString:[url absoluteString]
                                     parameters:parameters
                                          error:&serializationError];

    }
    
    //TODO: uncomment to show real HTTPBody
//    NSData *data = [request HTTPBody];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", string);

    if (serializationError) {
        if (self.shouldLogRequest) {
            NSLog(@"Serialization error: %@", serializationError);
        }
    }

    [self prepareURLRequest:request];

    return request;
}

- (AFHTTPRequestSerializer *)serializer:(AFHTTPSessionManager *)httpClient
{
    return [httpClient requestSerializer];
}

- (void)prepareURLRequest:(NSMutableURLRequest*)request
{
    // This is a point to customize URL request
    // E.g. set timeout interval or cache policy
    [request setTimeoutInterval:20.0];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
}

@end
