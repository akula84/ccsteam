//
//  RCShareCoordinateUrlAPI.m
//  Recity
//
//  Created by ezaji.dm on 15.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCShareCoordinateUrlAPI.h"

@implementation RCShareCoordinateUrlAPI

- (NSString *)path
{
    return kAPIShareCoordinateUrl;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

@end
