//
//  API+RequestProgress.m
//  Sample
//
//  Created by Alexander Kozin on 04.07.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "API_Protected.h"

@implementation API (RequestProgress)

- (void)sendRequestWithCompletion:(void (^)(id reply, NSError *error, BOOL *handleError))completion
{
    self.resendRequestAttemts = 3;
    [self setCompletion:completion];

    if ([API networkIsReachable]) {
        [self sendRequest];
    } else {
        [self invokeApiNotReachableSequence];
    }
}

- (void)sendRequest
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSMutableURLRequest *request = [self createRequest];
        
        NSURLSessionDataTask *task;
        task = [self dataTaskWithRequest:request
                         completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                             self.responseStatusCode = ((NSHTTPURLResponse *)response).statusCode;
                             [self removeProgressObserver];
                             
                             if (self.shouldLogRequest) {
                                 NSLog(@"%@",responseObject);
                             }
                                if (error) {
                                     NSError *apiError = [self apiErrorFromNetworkError:error];
                                    
                                    id errors;  // is array only
                                    id err = responseObject[@"error"];
                                    if ([err isKindOfClass:[NSDictionary class]]){
                                        errors = [err allValues];
                                    }
                                    else if ([err isKindOfClass:[NSString class]]){
                                        errors = @[err];
                                    }
                                    else {  // if array
                                        errors = err;
                                    }

                                     if (errors) {
                                         NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:apiError.userInfo];
                                         userInfo[@"errors"] = errors;
                                         apiError = [NSError errorWithDomain:apiError.domain code:apiError.code userInfo:userInfo];
                                     }
                                    //resend request
                                    if (self.resendRequestAttemts > 0 && (error.code == NSURLErrorTimedOut ||  error.code == NSURLErrorNetworkConnectionLost ) )
                                    {
                                        if (self.shouldLogRequest)
                                        {
                                            NSLog(@"error - %@, resend request attempt #%li",error.localizedDescription, (long)self.resendRequestAttemts);
                                        }
                                        self.resendRequestAttemts--;
                                        [self sendRequest];
                                    } else {
                                        [self apiDidFailWithError:apiError];
                                    }
                                    
                                } else {
                                 [self requestDidReturnReply:responseObject];
                                }
                         }];
        
        [task resume];
        [self setSessionTask:task];

        if (self.shouldLogRequest) {
            NSString *requestString = [NSString stringWithFormat:@"#AF request %@: %@\nHeaders: %@\n Parameters: %@", self.method,
                                       request.URL,
                                       request.allHTTPHeaderFields,
                                       [self parameters]];
            if (requestString.length > 10000) {
                requestString = [NSString stringWithFormat:@"%@...", [requestString substringToIndex:10000]];
            }
            NSLog(@"%@",requestString);
        }
    });
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSURLSessionDataTask *task;
    AFHTTPSessionManager *client = [API httpClient];
    
    if (self.files.count) {
        NSProgress *progress;
        task = [client uploadTaskWithStreamedRequest:request progress:nil /*&progress*/ completionHandler:completionHandler];
        [self removeProgressObserver];
        self.progress = progress;
        [self addProgressObserver];
    } else {
         task = [client dataTaskWithRequest:request completionHandler:completionHandler];
    }
    
    return task;

}

- (void)removeProgressObserver
{
    if (self.progress) {
        @try{
            [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
        }@catch(id anException){
        }
    }
}

- (void)addProgressObserver
{
   [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(API*)api change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && self.progressBlock) {
        self.progressBlock(self.progress);
    }
}

- (void)requestDidReturnReply:(id)reply
{
    id parsedReply = reply;

    Class classForParcingReply = [self classForParsingReply];
    if (classForParcingReply) {
        parsedReply = [classForParcingReply objectFromReply:reply];
    }
    [self apiDidReturnReply:parsedReply source:reply];
}

- (Class)classForParsingReply
{
    return NULL;
}

- (void)cancel
{
    [self.sessionTask cancel];
}

- (BOOL)apiRequestInProgress
{
    return self.sessionTask != nil;
}

@end
