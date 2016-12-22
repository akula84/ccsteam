//
//  RCMapDelegate+Annotations.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate_Private.h"

#import "RCProject.h"
#import "RCAnnotationProject.h"
#import "MKMapView+RCZoomLevel.h"
#import "RCAddress.h"
#import "RCAnnotationAddress.h"

@implementation RCMapDelegate (Annotations)

- (void)setAnnotationsForProjects:(NSArray <RCProject *> *)projects
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    for (RCProject *project in projects) {
        RCAnnotationProject *annotation = [RCAnnotationProject itemWithProject:project];
        [annotations addObject:annotation];
    }

    self.clusteringManager.delegate = nil;
    self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:annotations];
    self.clusteringManager.delegate = self;
    
    [self displayAnnotations];
}

- (void)displayAnnotations
{
    [self displayAnnotations:nil];
}

- (void)displayAnnotations:(void(^)())complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSArray *annotationsToShow = [self annotationsToShow];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.clusteringManager displayAnnotations:annotationsToShow onMapView:self.mapView];
            RUN_BLOCK(complete);
        });
    });
}

- (NSArray *)annotationsToShow
{
    static double oldScale = 0;
    static NSUInteger oldMapZoom = 0;
    if (oldMapZoom == 0) {
        oldMapZoom = self.mapView.zoomLevel;
    }
    if (oldScale == 0) {
        oldScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
    } else if (oldMapZoom != self.mapView.zoomLevel) {
        oldMapZoom = self.mapView.zoomLevel;
        oldScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
    }
    
    NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:[self mapRectIncrease] withZoomScale:oldScale];
    NSMutableArray *annotationsToShow;
    BOOL clustersOff = self.mapView.zoomLevel >= 16;
    
    if (clustersOff) {
        annotationsToShow = [NSMutableArray array];
        for (FBAnnotationCluster *cluster in annotations) {
            if (![cluster isKindOfClass:[FBAnnotationCluster class]]) {
                [annotationsToShow addObject:cluster];
            } else {
                [annotationsToShow addObjectsFromArray:cluster.annotations];
            }
        }
    } else {
        annotationsToShow = [annotations copy];
    }
    return annotationsToShow;
}

- (void)clusteringBegins:(FBClusteringManager *)manager
{
    [self hideOverlaysIfNeeded];
}

- (id <RCAnnotationProtocol>)annotationForItem:(id)item
{
    if (!item) {return nil;}
    for (id <RCAnnotationProtocol> annotation in [self.clusteringManager.annotationsWithClusters copy]) {
        if (annotation == nil) {
            continue;
        }
        if ([annotation isKindOfClass:[RCAnnotationProject class]]) {
            RCAnnotationProject *ann = (RCAnnotationProject *)annotation;
            if ([ann.project.uid isEqualToNumber:[item uid]]) {
                return annotation;
            }
        }
        if ([annotation isKindOfClass:[RCAnnotationAddress class]]) {
            RCAnnotationAddress *ann = (RCAnnotationAddress *)annotation;
            if ([ann.address.address isEqualToString:[(RCAddress *)item address]]) {
                return annotation;
            }
        }
    }
    return nil;
}

- (void)reloadAnnotationFrom:(id)item
{
    id <RCAnnotationProtocol>ann = [self annotationForItem:item];
    [self reloadImageAnn:ann];
}

- (void)reloadImageAnn:(id <RCAnnotationProtocol>)annotation
{
    UIImage *image = [annotation image];
    if (image) {
        [self.mapView viewForAnnotation:annotation].image = image;
    }
}

@end
