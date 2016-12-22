//
//  RCPolygonRenderer.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 25.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPolygonRenderer.h"

#import "RCProject.h"
#import "RCColoredPolygon.h"

@implementation RCPolygonRenderer

- (void)update
{
    RCColoredPolygon *polygon = (RCColoredPolygon *)self.overlay;
    RCProject *project = polygon.project;
    
    self.strokeColor = [project borderColorForCurrentStatus];
    if ([project projectStatus] == ProjectStatusUnnannounced) {
        self.lineDashPattern = @[@4, @6];
    } else {
        self.lineDashPattern = nil;
    }
    self.lineWidth = 3.0;
    
    if ([project projectStatus] == ProjectStatusUnnannounced ) {
        self.fillColor = [UIColor clearColor];
    } else {
        UIColor *fillColor = [project colorForCurrentStatus];
        self.fillColor = [project isSelected] ? [fillColor colorWithAlphaComponent:1.0f] : [fillColor colorWithAlphaComponent:0.75f];
    }
}

@end
