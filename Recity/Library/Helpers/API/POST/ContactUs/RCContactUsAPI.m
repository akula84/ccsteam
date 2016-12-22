//
//  RCContactUsAPI.m
//  Recity
//
//  Created by ezaji.dm on 10.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCContactUsAPI.h"

@implementation RCContactUsAPI

- (NSString *)path
{
    return kAPIContactUs;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

@end
