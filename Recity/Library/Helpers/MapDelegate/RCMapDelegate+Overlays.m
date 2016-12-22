//
//  RCMapDelegate+Overlays.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate_Private.h"

#import "RCTileOverlay.h"
#import "RCProject.h"
#import "RCShape.h"
#import "RCPoint.h"
#import "RCColoredPolygon.h"
#import "RCAnnotationProject.h"
#import "MKMapView+RCZoomLevel.h"

static NSString * const kMapBoxURLString = @"https://api.mapbox.com/v4/recity.abecc958/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicmVjaXR5IiwiYSI6ImU4MTJmZmE4MGY2ZjI0NzZkMmJjMjNhMzVlMzJiNjM0In0.bNRpbn4mMB4EPHFQ4efrsA";

@implementation RCMapDelegate (Overlays)

- (void)configureOverlay
{
    MKTileOverlay *overlay = [[RCTileOverlay alloc] initWithURLTemplate:kMapBoxURLString];
    overlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
}

- (void)addOverlayForProject:(RCProject *)project
{
    if (project.shapes) {
        for (RCShape *shape in project.shapes) {
            NSOrderedSet *points = shape.shapePoints;
            NSUInteger count = points.count;
            CLLocationCoordinate2D coordinates[count];
            
            for (NSUInteger i = 0; i < points.count; i++) {
                RCPoint *point = points[i];
                coordinates[i] = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
            }
            RCColoredPolygon *polygon = [RCColoredPolygon polygonWithCoordinates:coordinates count:count];
            polygon.project = project;
            if (![self.projectOverlays containsObject:polygon]) {
                [self.projectOverlays addObject:polygon];
            }
        }
    }
}

- (void)hideOverlaysIfNeeded
{
    if (!self.mapView.annotations.isFull) {
        return;
    }
    
    NSMutableSet *singleProjectsUids = [NSMutableSet set];

    for (RCAnnotationProject *annotation in self.clusteringManager.annotationsWithClusters) {
        if (annotation == nil) {
            continue;
        }
        if ([annotation isKindOfClass:[RCAnnotationProject class]]) {
            if (annotation.project) {
                [singleProjectsUids addObject:annotation.project.uid];
            }
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project.uid IN %@", singleProjectsUids];
    NSArray *overlays = [self.projectOverlays filteredArrayUsingPredicate:predicate];
    [self.mapView removeOverlays:self.projectOverlays];
    [self.mapView addOverlays:overlays level:MKOverlayLevelAboveLabels];
}

- (void)removeOverlays
{
    [self.mapView removeOverlays:self.projectOverlays];
    [self.projectOverlays removeAllObjects];
}

- (void)addOverlaysForProjects:(NSArray <RCProject *> *)projects
{
    [self removeOverlays];
    for (RCProject *project in projects) {
        if (![project isKindOfClass:[RCProject class]]) {
            continue;
        }
        [self addOverlayForProject:project];
    }
    [self.mapView addOverlays:self.projectOverlays];
}

@end
