//
//  MKMapView+RCZoomLevel.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 21.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "MKMapView+RCZoomLevel.h"

@implementation MKMapView (RCZoomLevel)

- (void)setZoomLevel:(NSUInteger)zoomLevel {
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomLevel animated:NO];
}

- (NSUInteger)zoomLevel {
    return (NSUInteger)log2(360 * ((self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1;
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*self.frame.size.width/256);
    [self setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}

@end
