//
//  RCMapDelegate.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 19.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotation.h"
#import "RCClusterImageCache.h"
#import "RCMapDelegate.h"
#import "RCProject.h"
#import "RCTileOverlay.h"
#import "RCShape.h"
#import "RCPoint.h"
#import "RCTransformer.h"
#import "MKMapView+RCZoomLevel.h"
#import "FBAnnotationClustering/FBAnnotationClustering.h"
//#import "FBAnnotationCluster+RCProjectAssociation.h"
#import "RCClusterAnnotationView.h"
#import "RCColoredPolygon.h"


static NSString * const kMapBoxURLString = @"https://api.mapbox.com/v4/recity.abecc958/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicmVjaXR5IiwiYSI6ImU4MTJmZmE4MGY2ZjI0NzZkMmJjMjNhMzVlMzJiNjM0In0.bNRpbn4mMB4EPHFQ4efrsA";
static NSUInteger const kZoomLevelMaxForProjectOverlays = 15;


@interface RCMapDelegate () <MKMapViewDelegate, FBClusteringManagerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FBClusteringManager *clusteringManager;

@property (strong, nonatomic) NSMutableArray <id<MKOverlay>> *projectOverlays;
@property (strong, nonatomic) NSMutableArray <MKPolygonRenderer *> *projectPolygons;

@property (strong, nonatomic) NSMutableArray *annotations;
@property (assign, nonatomic) BOOL regionWasBelowMaxZoomLevel;
@property (copy, nonatomic) NSArray *allProjects;
@property (strong, nonatomic) NSArray *selectedPolygons;

@property (assign, nonatomic) MKMapRect mapRect;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation RCMapDelegate

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Wait until User Location is initialized (NOT 0,0)
    NSLog(@"Latitude: %f, Longitude: %f",_mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude);
    if(_mapView.userLocation.location.coordinate.latitude!=0.00 && _mapView.userLocation.location.coordinate.longitude!=0.00){
        CLLocation *location = locations.firstObject;
        _mapView.userLocation.coordinate = location.coordinate;
    }
}

#pragma mark - Properties

- (void)setMapView:(MKMapView *)mapView {
    _mapView.delegate = nil;
    _mapView = (id)mapView;
    [self configureOverlay];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    CLLocationCoordinate2D washingtonCoordinate = CLLocationCoordinate2DMake(38.89399, -77.03659);
    [_mapView setCenterCoordinate:washingtonCoordinate zoomLevel:kZoomLevelMaxForProjectOverlays animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectFavoriteChanged:) name:kProjectFavoriteChangedNotification object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDistanceFilter:100.0];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [self.locationManager startUpdatingLocation];
}

- (void)projectFavoriteChanged:(NSNotification *)notification {
    RCProject *project = notification.object;
    
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[RCAnnotation class]]) {
            return;
        }
        RCAnnotation *annotation = (RCAnnotation *)obj;
        if (annotation.project.uid.integerValue == project.uid.integerValue) {
            [self.mapView viewForAnnotation:annotation].image = [self imageForAnnotation:annotation];
        }
    }];
}

- (void)updateImagesOfAllDisplayedAnnotations {
    for (RCAnnotation *annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[RCAnnotation class]]) {
            [self.mapView viewForAnnotation:annotation].image = [self imageForAnnotation:annotation];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<id<MKOverlay>> *)projectOverlays {
    if (_projectOverlays != nil) {
        return _projectOverlays;
    }
    
    _projectOverlays = [NSMutableArray array];
    
    return _projectOverlays;
}

- (NSMutableArray<MKPolygonRenderer *> *)projectPolygons {
    if (_projectPolygons != nil) {
        return _projectPolygons;
    }
    
    _projectPolygons = [NSMutableArray array];
    
    return _projectPolygons;
}

#pragma mark - Overlays

- (void)configureOverlay {
    MKTileOverlay *overlay = [[RCTileOverlay alloc]initWithURLTemplate:kMapBoxURLString];
    overlay.canReplaceMapContent = YES;
    [_mapView addOverlay:overlay level:MKOverlayLevelAboveLabels];
}

-(MKOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[RCColoredPolygon class]]) {
        MKPolygonRenderer *lineView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        
        lineView.lineWidth = 2;
        lineView.strokeColor = [(RCColoredPolygon *)overlay borderColor];
        lineView.fillColor = [(RCColoredPolygon *)overlay color];
        
        [self.projectPolygons addObject:lineView];
        
        return lineView;
    }
    return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
}

- (void)showProjects:(NSArray<RCProject *> *)projects {
//    projects = [projects subarrayWithRange:NSMakeRange(0, 1)];
    if (self.allProjects.count > 0) {
        return;
    }
    self.allProjects = projects;
    
    [self setAnnotationsForProjects:projects];
    
    [self addOverlaysForProjects:projects];
}

- (void)addOverlaysForProjects:(NSArray<RCProject *> *)projects {
    if (self.projectOverlays.count > 0) {
        //TODO: replace dynamically overlay with new fetched one if needed
        
        return;
    }
    @synchronized (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            for (RCProject *project in projects) {
                if (![project isKindOfClass:[RCProject class]]) {
                    continue;
                }
                [self addOverlayForProject:project];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addOverlays:self.projectOverlays level:MKOverlayLevelAboveLabels];
            });
        });
    }
}

- (void)addOverlayForProject:(RCProject *)project {
    for (RCShape *shape in project.shapes) {
        NSOrderedSet *points = shape.shapePoints;
        NSUInteger count = points.count;
        CLLocationCoordinate2D coordinates[count];
        
        for (int i = 0; i < points.count; i++) {
            RCPoint *point = points[i];
            coordinates[i] = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
        }
        RCColoredPolygon *polygon = [RCColoredPolygon polygonWithCoordinates:coordinates count:count];
        polygon.project = project;
        polygon.borderColor = [project borderColorForCurrentStatus];
        polygon.color = [[project colorForCurrentStatus]colorWithAlphaComponent:0.75];
        [self.projectOverlays addObject:polygon];
    }
}

- (void)hideOverlaysIfNeeded {
    BOOL farForContours = self.mapView.zoomLevel < kZoomLevelMaxForProjectOverlays;
    if (farForContours && !self.regionWasBelowMaxZoomLevel) {
        [self hideProjectOverlays:YES];
    } else if (!farForContours && self.regionWasBelowMaxZoomLevel) {
        [self hideProjectOverlays:NO];
    }
}

- (void)hideProjectOverlays:(BOOL)hide {
    for (MKPolygonRenderer *polygon in self.projectPolygons) {
        polygon.strokeColor = [polygon.strokeColor colorWithAlphaComponent:hide ? 0. : 1.];

        BOOL isSelected = [self.selectedPolygons containsObject:polygon];
        CGFloat alphaComponent = hide ? 0. : .75;
        alphaComponent = !hide && isSelected ? 1. : alphaComponent;
        
        polygon.fillColor = [polygon.fillColor colorWithAlphaComponent:alphaComponent];
    }
}

- (void)removeOverlays {
    [self.mapView removeOverlays:self.projectOverlays];
    [self.projectOverlays removeAllObjects];
}

- (void)setPolygons:(NSArray <MKPolygonRenderer *> *)polygons highlighted:(BOOL)highlighted {
    CGFloat alpha = highlighted ? 1. : 0.75;
    for (MKPolygonRenderer *polygon in polygons) {
        polygon.fillColor = [polygon.fillColor colorWithAlphaComponent:alpha];
    }
}

#pragma mark Annotations

- (void)setAnnotationsForProjects:(NSArray<RCProject *> *)projects {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *annotations = [NSMutableArray array];
        
        __block CLLocationCoordinate2D upperLeft = CLLocationCoordinate2DMake(-CGFLOAT_MAX, CGFLOAT_MAX);
        __block CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(CGFLOAT_MAX, CGFLOAT_MAX);
        __block CLLocationCoordinate2D upperRight = CLLocationCoordinate2DMake(-CGFLOAT_MAX, -CGFLOAT_MAX);
        
        __unused void (^checkForBoudaries)(RCProject *) = ^(RCProject *project) {
            CGFloat longitude = project.centerPoint.longitude.floatValue;
            CGFloat latitude = project.centerPoint.latitude.floatValue;
            if (upperLeft.longitude > longitude) {
                upperLeft.longitude = longitude;
            }
            if (upperLeft.latitude < latitude) {
                upperLeft.latitude = latitude;
            }
            if (bottomLeft.longitude > longitude) {
                bottomLeft.longitude = longitude;
            }
            if (bottomLeft.latitude > latitude) {
                bottomLeft.latitude = latitude;
            }
            if (upperRight.longitude < longitude) {
                upperRight.longitude = longitude;
            }
            if (upperRight.latitude < latitude) {
                upperRight.latitude = latitude;
            }
        };
        
        for (RCProject *project in projects) {
            RCAnnotation *annotation = [self createAnnotationForProject:project];
            [annotations addObject:annotation];
            
//            checkForBoudaries(project);
        }
        
//        MKMapPoint mk_upperLeft = MKMapPointForCoordinate(upperLeft);
//        MKMapPoint mk_lowerLeft = MKMapPointForCoordinate(bottomLeft);
//        MKMapPoint mk_upperRight = MKMapPointForCoordinate(upperRight);
//        
//        self.mapRect = MKMapRectMake(mk_upperLeft.x, mk_upperLeft.y, fabs(mk_upperLeft.x - mk_upperRight.x), fabs(mk_upperLeft.y - mk_lowerLeft.y));
        
        self.clusteringManager.delegate = nil;
        self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:annotations];
        self.clusteringManager.delegate = self;
        self.annotations = annotations;
        [self displayAnnotations];
    });
}

- (void)displayAnnotations {
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
    
    @try {
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:self.mapView.visibleMapRect withZoomScale:oldScale];
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
        [self.clusteringManager displayAnnotations:annotationsToShow onMapView:self.mapView];
    } @catch(NSException *e) {}
}

- (RCAnnotation *)createAnnotationForProject:(RCProject *)project {
    RCAnnotation *result = [RCAnnotation new];
    RCPoint *pt = project.centerPoint;
    result.coordinate = CLLocationCoordinate2DMake(pt.latitude.doubleValue, pt.longitude.doubleValue);
    result.project = project;
    return result;
}

#pragma mark - Map

- (IBAction)showMyself:(id)sender {
    if (self.mapView.userLocation.location == nil) {
        
        return;
    }
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate zoomLevel:16 animated:YES];
}

- (void)displayOverlayForProject:(RCProject *)project {
    [self addOverlaysForProjects:@[project]];
}

#pragma mark - FBClusteringManagerDelegate

- (CGFloat)cellSizeFactorForCoordinator:(FBClusteringManager *)coordinator {
    return 2.5;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.regionWasBelowMaxZoomLevel = mapView.zoomLevel < kZoomLevelMaxForProjectOverlays;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BOOL farForContours = self.mapView.zoomLevel < kZoomLevelMaxForProjectOverlays;
    if (farForContours && !self.regionWasBelowMaxZoomLevel) {
        [self.mapView removeOverlays:self.projectOverlays];
    } else if (!farForContours && self.regionWasBelowMaxZoomLevel) {
        [self.mapView addOverlays:self.projectOverlays];
    }
    
    static NSOperationQueue *fetchingQueue;
    if (fetchingQueue == nil) {
        fetchingQueue = [NSOperationQueue new];
    };
    [fetchingQueue addOperationWithBlock:^{
        [self displayAnnotations];
    }];
    
    [self hideOverlaysIfNeeded];
    
    PERFORM_BLOCK_IF_NOT_NIL(self.didMove, self, mapView);
}

- (NSArray <RCProject *> *)projectsFromAnnotations:(NSArray *)annotations {
    NSMutableArray *projects = [NSMutableArray array];
    
    for (RCAnnotation *annotation in annotations) {
        if ([annotation isKindOfClass:[RCAnnotation class]]) {
            [projects addObject:annotation.project];
        } else if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
            [projects addObjectsFromArray:[annotation valueForKeyPath:@"annotations.project"]];
        }
    }
    
    return projects;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self setPolygons:self.selectedPolygons highlighted:NO];
    
    RCAnnotation<MKAnnotation> *annotation = view.annotation;
    
    if ([annotation isKindOfClass:[RCAnnotation class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            NSArray *overlays = [self.projectPolygons valueForKeyPath:@"polygon"];
            NSArray *projects = [overlays valueForKeyPath:@"project"];
            
            __unused NSIndexSet *set = [projects indexesOfObjectsPassingTest:^BOOL(RCProject  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [annotation.project.uid isEqualToNumber:obj.uid];
            }];
            NSMutableArray *polygonsToHighlight = [NSMutableArray array];
            [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                MKPolygonRenderer *polygon = self.projectPolygons[idx];
                [polygonsToHighlight addObject:polygon];
            }];
            self.selectedPolygons = polygonsToHighlight;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setPolygons:self.selectedPolygons highlighted:YES];
                PERFORM_BLOCK_IF_NOT_NIL(self.didSelectProject, self, annotation.project);
            });
        });
    } else if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        [self.mapView setCenterCoordinate:annotation.coordinate zoomLevel:self.mapView.zoomLevel + 1 animated:YES];
    }
    [mapView deselectAnnotation:annotation animated:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        RCClusterAnnotationView * clusterView = (RCClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        if (!clusterView) {
            clusterView = [[RCClusterAnnotationView alloc] initWithAnnotation:annotation
                                                   reuseIdentifier:@"cluster"];
            clusterView.canShowCallout = NO;
        }
        clusterView.annotation = annotation;
        [clusterView setCount:[(FBAnnotationCluster *)annotation annotations].count];
        
        return clusterView;
    }
    MKAnnotationView * pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"Annotation"];
        pinView.canShowCallout = NO;
    }
    else {
        pinView.annotation = annotation;
    }
    
    UIImage *image = [self imageForAnnotation:annotation];
    pinView.image = image;
    
    return pinView;
}

- (UIImage *)imageForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        NSParameterAssert(NO);
        return nil;
    }
    NSString *imageName = ({
        RCAnnotation *singleAnnotation = annotation;
        RCProject *project = singleAnnotation.project;
        NSString *markerImageName = [project mapPinImageNameForUser:[AppState sharedInstance].user];
        markerImageName;
    });
    
    return [UIImage imageNamed:imageName];
}

@end
