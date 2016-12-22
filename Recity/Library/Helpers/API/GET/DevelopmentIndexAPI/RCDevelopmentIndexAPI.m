//
//  RCDevelopmentIndexAPI.m
//  Recity
//
//  Created by Artem Kulagin on 14.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexAPI.h"

#import "API_Protected.h"
#import "RCParseHelper.h"

@implementation RCDevelopmentIndexAPI

- (NSString *)path
{
    return kAPIGetGeoCoordinateChangeScore;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
      [super apiDidReturnReply:reply source:source];
}

@end
