//
//  RCAnnotation.h
//  Recity
//
//  Created by Artem Kulagin on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol RCAnnotationProtocol <NSObject,MKAnnotation>

@property (readonly, nonatomic) CLLocationCoordinate2D searchCoordinate;

@optional
- (UIImage *)image;

@end
