//
//  RCColoredPolygon.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 29.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RCColoredPolygon : MKPolygon

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *borderColor;
@property (weak, nonatomic) id project;
@end
