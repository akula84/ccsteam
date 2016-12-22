//
//  RCColoredPolygon.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 29.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <MapKit/MapKit.h>

@class RCProject;

@interface RCColoredPolygon : MKPolygon

@property (strong, nonatomic) RCProject *project;

@end
