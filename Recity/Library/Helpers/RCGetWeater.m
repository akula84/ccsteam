//
//  TWCGetWeater.m
//  TestWorkCcsteam
//
//  Created by Artem Kulagin on 21.12.16.
//  Copyright © 2016 Artem Kulagin. All rights reserved.
//

#import "RCGetWeater.h"

#import "API_Protected.h"
#import "RCMap+CoreDataClass.h"

@implementation RCGetWeater

- (NSString *)path{
    return kWeather;
}

- (NSMutableDictionary *)parameters{
    return self.object;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    id map = [RCMap MR_importFromObject:reply];
    [super apiDidReturnReply:map source:source];
}

@end
