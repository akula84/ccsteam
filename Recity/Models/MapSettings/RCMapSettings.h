//
//  RCMapSettings.h
//  Recity
//
//  Created by ezaji.dm on 25.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

@interface RCMapSettings : NSObject <NSCoding>

+ (instancetype)defaultMapSettings;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithMapCenterCoordinate:(CLLocationCoordinate2D)mapCenterCoordinate
                               mapZoomLevel:(NSUInteger)mapZoomLevel NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, readonly) NSUInteger zoomLevel;

- (void)setNewCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  newZoomLevel:(NSUInteger)zoomLevel;

@end
