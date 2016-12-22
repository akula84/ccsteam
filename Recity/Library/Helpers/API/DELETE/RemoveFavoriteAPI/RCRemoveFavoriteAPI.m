//
//  RCRemoveFavoriteAPI.m
//  Recity
//
//  Created by Artem Kulagin on 14.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCRemoveFavoriteAPI.h"

#import "API_Protected.h"

@implementation RCRemoveFavoriteAPI

- (NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@",kAPIRemoveFavorite,self.object[kId]];
}

- (NSMutableDictionary *)parameters
{
    return nil;
}

@end
