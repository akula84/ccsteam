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

/**
 *  @return weater from name q http://api.openweathermap.org/data/2.5/weather
 */
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
