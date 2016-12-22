//
//  MKMapView+RCZoomLevel.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 21.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (RCZoomLevel)

@property (assign, nonatomic) NSUInteger zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
