//
//  NSNumber+CLLocationDistance.m
//  Recity
//
//  Created by Artem Kulagin on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSNumber+CLLocationDistance.h"

static double const koefMiles = 0.621371192f;

@implementation NSNumber (CLLocationDistance)

- (NSNumber *)kmToMiles
{
    return @(self.doubleValue * koefMiles);
}

- (NSNumber *)milesToKm
{
    return @(self.doubleValue/koefMiles);
}

@end
