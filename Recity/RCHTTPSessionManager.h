//
//  RCHTTPSessionManager.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 08.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "RCBaseRequest.h"

@interface RCHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)shared;
+ (NSString *)baseURLString;

/**
 *  TODO: cache requests, block can be ignored if cache failed. DB will be changed already up to this moment
 *
 *  @param request    RCBaseRequest. make an assertion if some parameters of request not filled.
 *  @param completion 
 */
- (PMKPromise *)loadRequest:(RCBaseRequest *)request uploadProgress:(ProgressBlock)uploadProgress downloadProgress:(ProgressBlock)downloadProgress;
- (PMKPromise *)loadRequest:(RCBaseRequest *)request;

- (PMKPromise *)authWithLogin:(NSString *)login password:(NSString *)password;

@end
