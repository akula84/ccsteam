//
//  RCAnnotation.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 27.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RCProject;

@interface RCAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) RCProject *project;
@property (assign, nonatomic) CLLocationCoordinate2D tempoCoordinate;

@end