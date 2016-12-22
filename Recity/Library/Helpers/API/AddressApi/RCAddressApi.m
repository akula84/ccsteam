//
//  RCAddressApi.m
//  Recity
//
//  Created by Artem Kulagin on 01.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddressApi.h"

#import "API_Protected.h"

@implementation RCAddressApi

- (NSString *)path
{
    return kAPIAddress;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

@end
