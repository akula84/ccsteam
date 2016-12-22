//
//  RCMapDelegate+Select.m
//  Recity
//
//  Created by Artem Kulagin on 16.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate.h"
#import "RCMapDelegate_Private.h"

#import "RCColoredPolygon.h"
#import "RCFilterManager.h"
#import "RCProject.h"
#import "RCAnnotationProject.h"
#import "RCMapController.h"
#import "MyLocationButtonController.h"

@implementation RCMapDelegate (Select)

- (void)selectProject:(RCProject *)project
{
    [MyLocationButtonController prepareActived:NO];
    if ([project isSelected]) {
        return;
    }
    
    [self deSelectCurrentItem];

    MKMapView *mapView = self.mapView;
    if (project) {
        [RCMapController shared].selectedItem = project;
        [self reloadAnnotationFrom:project];
        [self addSelectedPinIfNeed];
        RCColoredPolygon *polygon = [self currentPolygon];
        if (!polygon) {return;}
        [mapView removeOverlay:polygon];
        [mapView addOverlay:polygon];
    }
}

- (void)deSelectCurrentProject
{
    RCColoredPolygon *polygon = [self currentPolygon];
    if (!polygon) {return;}
    MKMapView *mapView = self.mapView;
    
    RCProject *selectedProject = [self selectedProject];
    [RCMapController selectedClear];
    [self reloadAnnotationFrom:selectedProject];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProjectsLoaded object:nil];
    
    [mapView removeOverlay:polygon];
    if ([self filterContains:selectedProject]) {
        [mapView addOverlay:polygon];
    } else {
        [self removeSelectedPin:selectedProject];
    }
}

- (BOOL)filterContains:(RCProject *)project
{
    return [[RCFilterManager shared] isFilteredProjectsContainsProject:project];
}

- (RCProject *)selectedProject
{
    return [RCMapController selectedProject];
}

- (void)addSelectedPinIfNeed
{
    RCProject *project = [self selectedProject];
    if (![self filterContains:project]) {
        RCAnnotationProject *annotation = [RCAnnotationProject itemWithProject:project];
        [self.clusteringManager addAnnotations:@[annotation]];
        [self displayAnnotations];
        if (![self currentPolygon]) {
            [self addOverlayForProject:project];
        }
    }
}

- (void)removeSelectedPin:(RCProject *)item
{
    RCAnnotationProject *annotation = [self annotationForItem:item];
    if (annotation) {
        [self.clusteringManager removeAnnotations:@[annotation]];
        [self.mapView removeAnnotation:annotation];
    }
}

- (RCColoredPolygon *)currentPolygon
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project.uid = %@",[self selectedProject].uid];
    return [self.projectOverlays filteredArrayUsingPredicate:predicate].firstObject;
}

@end
