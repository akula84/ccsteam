//
//  CachingAPI.m
//  TraxMove
//
//  Created by Alexander Kozin on 31.08.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "CachingAPI.h"
#import "API_Protected.h"

@implementation CachingAPI

- (void)invokeApiNotReachableSequence
{
    AFHTTPSessionManager *client = [API httpClient];
    
    NSMutableURLRequest *request = [self createRequest];
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    if (cachedResponse) {
        NSError *error = nil;
        id responseObject = [client.responseSerializer responseObjectForResponse:cachedResponse.response
                                                                            data:cachedResponse.data
                                                                           error:&error];
        if (error) {
            NSError *apiError = [self apiErrorFromNetworkError:error];
            [self apiDidFailWithError:apiError];
        } else {
            [self requestDidReturnReply:responseObject];
        }
    } else {
        [super invokeApiNotReachableSequence];
    }
}

@end
