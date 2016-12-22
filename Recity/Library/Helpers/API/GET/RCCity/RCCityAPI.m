//
//  RCCityAPI.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCCityAPI.h"

#import <MagicalRecord/MagicalRecord.h>
#import "API_Protected.h"
#import "RCCity.h"
#import "RCParseHelper.h"

@implementation RCCityAPI

- (NSString *)path
{
    return kAPIGetCities;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    [RCParseHelper parseSaveArray:reply aClass:[RCCity class] completion:^(NSArray *array) {
        [super apiDidReturnReply:array source:source];
    }];
}

@end
