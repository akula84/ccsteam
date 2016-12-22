//
//  RCMapDelegate_Private.h
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "RCMapDelegate.h"

#import "FBAnnotationClustering.h"
#import "RCAnnotationProtocol.h"

@class RCPolygonRenderer, RCAnnotationProject;

@interface RCMapDelegate()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray <id<MKOverlay>> *projectOverlays;
@property (assign, nonatomic) BOOL regionWasBelowMaxZoomLevel;
@property (strong, nonatomic) FBClusteringManager *clusteringManager;

@property (strong ,nonatomic, readwrite) RCMapSettings *currentMapSettings;

- (MKMapRect)mapRectIncrease;

@end

@interface RCMapDelegate (Overlays)

- (void)configureOverlay;
- (void)addOverlayForProject:(RCProject *)project;
- (void)addOverlaysForProjects:(NSArray <RCProject *> *)projects;
- (void)hideOverlaysIfNeeded;

@end

@interface RCMapDelegate (Delegate)<MKMapViewDelegate>

@end

@interface RCMapDelegate (Annotations)

- (void)setAnnotationsForProjects:(NSArray <RCProject *> *)projects;
- (void)displayAnnotations;
- (void)displayAnnotations:(void(^)())complete;

- (void)reloadAnnotationFrom:(id)item;
- (id <RCAnnotationProtocol>)annotationForItem:(id)item;
- (void)reloadImageAnn:(id <RCAnnotationProtocol>)annotation;

@end

@interface RCMapDelegate (Map) <FBClusteringManagerDelegate>

- (void)projectFavoriteChanged:(NSNotification *)notification;
- (void)showObject:(id)object withYDesplacement:(CGFloat)displacement;

@end
