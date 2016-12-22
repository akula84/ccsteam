//
//  CLLocation+CLLocationCoordinate2D.h
//  Wacatch
//
//  Created by Artem Kulagin on 10.05.16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (CLLocationCoordinate2D)

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
