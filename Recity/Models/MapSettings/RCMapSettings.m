//
//  RCMapSettings.m
//  Recity
//
//  Created by ezaji.dm on 25.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapSettings.h"

@interface RCMapSettings ()

@property (nonatomic, readwrite) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, readwrite) NSUInteger zoomLevel;

@end

@implementation RCMapSettings

+ (instancetype)defaultMapSettings
{
    return [[self alloc] initWithMapCenterCoordinate:CLLocationCoordinate2DMake(38.89399, -77.03659)
                                        mapZoomLevel:kZoomLevelMaxForProjectOverlays];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        _centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        NSNumber *zoomLevel = [aDecoder decodeObjectForKey:@"zoomLevel"];
        _zoomLevel = zoomLevel.unsignedLongValue;
    }
    return self;
}

- (instancetype)initWithMapCenterCoordinate:(CLLocationCoordinate2D)mapCenterCoordinate
                               mapZoomLevel:(NSUInteger)mapZoomLevel
{
    if(self = [super init]) {
        _centerCoordinate = mapCenterCoordinate;
        _zoomLevel = mapZoomLevel;
    }
    return self;
}

- (void)setNewCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  newZoomLevel:(NSUInteger)zoomLevel
{
    self.centerCoordinate = centerCoordinate;
    self.zoomLevel = zoomLevel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.centerCoordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.centerCoordinate.longitude forKey:@"longitude"];
    [aCoder encodeObject:@(self.zoomLevel) forKey:@"zoomLevel"];
}

@end
