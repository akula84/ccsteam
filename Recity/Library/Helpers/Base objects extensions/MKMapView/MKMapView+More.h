//
//  MKMapView+More.h
//  Recity
//
//  Created by Matveev on 17/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (More)

- (CLLocationCoordinate2D)visuallyShiftedCoordinate:(CLLocationCoordinate2D)sourceCoordinate onAddedPixels:(CGPoint)offsetForAdd;

@end
