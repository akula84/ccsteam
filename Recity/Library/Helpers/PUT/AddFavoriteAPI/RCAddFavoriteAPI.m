//
//  RCAddFavoriteAPI.m
//  Recity
//
//  Created by Artem Kulagin on 14.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddFavoriteAPI.h"

#import "API_Protected.h"

@implementation RCAddFavoriteAPI

- (NSString *)path
{
    return kAddFavorite;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

- (AFHTTPRequestSerializer *)serializer:(AFHTTPSessionManager *)httpClient
{
    httpClient.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    return [httpClient requestSerializer];
}

@end
