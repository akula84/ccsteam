//
//  CLLocation+CLLocationCoordinate2D.m
//  Wacatch
//
//  Created by Artem Kulagin on 10.05.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

#import "CLLocation+CLLocationCoordinate2D.h"

@implementation CLLocation (CLLocationCoordinate2D)

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

@end
