//
//  MKMapView+More.m
//  Recity
//
//  Created by Matveev on 17/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "MKMapView+More.h"

@implementation MKMapView (More)

- (CLLocationCoordinate2D)visuallyShiftedCoordinate:(CLLocationCoordinate2D)sourceCoordinate onAddedPixels:(CGPoint)offsetForAdd {
    CLLocationCoordinate2D result;
    CGPoint convertedPoint = [self convertCoordinate:sourceCoordinate toPointToView:self];
    convertedPoint.x += offsetForAdd.x;
    convertedPoint.y += offsetForAdd.y;
    result = [self convertPoint:convertedPoint toCoordinateFromView:self];
    return result;
}

@end
