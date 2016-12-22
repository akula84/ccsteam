//
//  RCSearchAPI.m
//  Recity
//
//  Created by Artem Kulagin on 14.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchAPI.h"

#import "API_Protected.h"

@implementation RCSearchAPI

- (NSString *)path
{
    return kAPISearch;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

@end
