//
//  FBClusterManager.m
//  AnnotationClustering
//
//  Created by Filip Bec on 05/01/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FBClusteringManager.h"
#import "FBQuadTree.h"
#import "RCAnnotation.h"
#import "RCProject.h"

static NSString * const kFBClusteringManagerLockName = @"co.infinum.clusteringLock";

#pragma mark - Utility functions

NSInteger FBZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

CGFloat FBCellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = FBZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 12:
            return 200;
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
            
        default:
            return 1000;
    }
}

static CLLocationCoordinate2D emptyCoordinate = {0, 0};
BOOL coordinateIsEmpty(CLLocationCoordinate2D coord) {
    return coord.latitude == emptyCoordinate.latitude && coord.longitude == emptyCoordinate.longitude;
}

#pragma mark - FBClusteringManager

@interface FBClusteringManager ()

@property (nonatomic, strong) FBQuadTree *tree;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSLock *clusteringLock;

@end


@implementation FBClusteringManager

- (id)init
{
    return [self initWithAnnotations:nil];
}

- (id)initWithAnnotations:(NSArray *)annotations
{
    self = [super init];
    if (self) {
        _lock = [NSRecursiveLock new];
        _clusteringLock = [NSLock new];
        [self addAnnotations:annotations];
    }
    return self;
}

- (void)setAnnotations:(NSArray *)annotations
{
    self.tree = nil;
    [self addAnnotations:annotations];
}

- (void)addAnnotations:(NSArray *)annotations
{
    if (!self.tree) {
        self.tree = [[FBQuadTree alloc] init];
    }

    [self.lock lock];
    for (id<MKAnnotation> annotation in annotations) {
        [self.tree insertAnnotation:annotation];
    }
    [self.lock unlock];
}

- (void)removeAnnotations:(NSArray *)annotations
{
    if (!self.tree) {
        return;
    }

    [self.lock lock];
    for (id<MKAnnotation> annotation in annotations) {
        [self.tree removeAnnotation:annotation];
    }
    [self.lock unlock];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    return [self clusteredAnnotationsWithinMapRect:rect withZoomScale:zoomScale withFilter:nil];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale withFilter:(BOOL (^)(id<MKAnnotation>)) filter
{
    double cellSize = FBCellSizeForZoomScale(zoomScale);
    if ([self.delegate respondsToSelector:@selector(cellSizeFactorForCoordinator:)]) {
        cellSize *= [self.delegate cellSizeFactorForCoordinator:self];
    }
    double scaleFactor = zoomScale / cellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x/scaleFactor, y/scaleFactor, 1.0/scaleFactor, 1.0/scaleFactor);
            FBBoundingBox mapBox = FBBoundingBoxForMapRect(mapRect);
            
            __block double totalLatitude = 0;
            __block double totalLongitude = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc] init];

            [self.tree enumerateAnnotationsInBox:mapBox usingBlock:^(id<MKAnnotation> obj) {
                
                if(!filter || (filter(obj) == TRUE))
                {
                    totalLatitude += [obj coordinate].latitude;
                    totalLongitude += [obj coordinate].longitude;
                    [annotations addObject:obj];
                }
            }];
            
            NSInteger count = [annotations count];
            if (count == 1) {
                [clusteredAnnotations addObjectsFromArray:annotations];
            }
            
            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalLatitude/count, totalLongitude/count);
                FBAnnotationCluster *cluster = [[FBAnnotationCluster alloc] init];
                cluster.coordinate = coordinate;
                cluster.annotations = annotations;
                [clusteredAnnotations addObject:cluster];
            }
        }
    }
    [self.lock unlock];
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

- (NSArray *)allAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    [self.tree enumerateAnnotationsUsingBlock:^(id<MKAnnotation> obj) {
        [annotations addObject:obj];
    }];
    [self.lock unlock];
    
    return annotations;
}

- (void)displayAnnotations:(NSArray *)annotations onMapView:(MKMapView *)mapView
{
    NSMutableSet *before = [NSMutableSet setWithArray:mapView.annotations];
    MKUserLocation *userLocation = [mapView userLocation];
    if (userLocation) {
        [before removeObject:userLocation];
    }
    
    NSSet *after = [NSSet setWithArray:annotations];
    
    //[cluster1, arrayOfSubclusters1, cluster2, arrayOfSubclusters2
//    NSMutableArray *clustersWithSubClusters = [NSMutableArray array];
//    for (FBAnnotationCluster *cluster in <#collection#>) {
//        <#statements#>
//    }
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *afterPure = [after mutableCopy];
    [afterPure minusSet:toKeep];
    
    NSMutableSet *beforePure = [before mutableCopy];
    [beforePure minusSet:toKeep];
    
    NSMutableSet *dividingClusters = [NSMutableSet set];
    NSMutableSet *buildingClusters = [NSMutableSet set];
    
    for (FBAnnotationCluster *afterAnnotation in afterPure) {
        NSMutableSet *afterSubAnnotations = [NSMutableSet set];
        if ([afterAnnotation isKindOfClass:[FBAnnotationCluster class]]) {
            [afterSubAnnotations addObjectsFromArray:afterAnnotation.annotations];
        } else {
            [afterSubAnnotations addObject:afterAnnotation];
        }
        
        for (FBAnnotationCluster *beforeAnnotation in beforePure) {
            NSMutableSet *beforeSubAnnotations = [NSMutableSet set];
            if ([beforeAnnotation isKindOfClass:[FBAnnotationCluster class]]) {
                [beforeSubAnnotations addObjectsFromArray:beforeAnnotation.annotations];
            } else {
                [beforeSubAnnotations addObject:beforeAnnotation];
            }
            NSMutableSet *beforeSubCopy = [beforeSubAnnotations mutableCopy];
            [beforeSubCopy minusSet:afterSubAnnotations];
            BOOL isClustering = beforeSubCopy.count == 0;
            if (isClustering) {
                beforeAnnotation.tempoCoordinate = afterAnnotation.coordinate;
                [buildingClusters addObject:afterAnnotation];
            }
            
            NSMutableSet *afterSubCopy = [afterSubAnnotations mutableCopy];
            [afterSubCopy minusSet:beforeSubAnnotations];
            BOOL isDividing = afterSubCopy.count == 0;
            if (isDividing) {
                afterAnnotation.tempoCoordinate = afterAnnotation.coordinate;
                afterAnnotation.coordinate = beforeAnnotation.coordinate;
                [dividingClusters addObject:beforeAnnotation];
            }
            
            // separated by different clusters
//            BOOL isBlowing =
        }
    }
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    [toAdd minusSet:buildingClusters];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    [toRemove minusSet:dividingClusters];
    
    NSMutableArray *annotationsWithChangedCoordinate = [NSMutableArray array];
    
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        mapView.userInteractionEnabled = toAdd.count == 0 && toRemove.count == 0;
        
        [mapView addAnnotations:[toAdd allObjects]];
        [mapView removeAnnotations:[dividingClusters allObjects]];
        
        [UIView animateWithDuration:0.25 animations:^{
            for (FBAnnotationCluster *annotation in beforePure) {
                if (!coordinateIsEmpty(annotation.tempoCoordinate)) {
                    CLLocationCoordinate2D tempo = annotation.tempoCoordinate;
                    annotation.tempoCoordinate = annotation.coordinate;
                    annotation.coordinate = tempo;
                    
                    [annotationsWithChangedCoordinate addObject:annotation];
                }
            }
            for (FBAnnotationCluster *annotation in afterPure) {
                if (coordinateIsEmpty(annotation.tempoCoordinate)) {
                    continue;
                }
                
                annotation.coordinate = annotation.tempoCoordinate;
                annotation.tempoCoordinate = emptyCoordinate;
            }
        } completion:^(BOOL finished) {
            for (FBAnnotationCluster *annotation in annotationsWithChangedCoordinate) {
                if (coordinateIsEmpty(annotation.tempoCoordinate)) {
                    continue;
                }
                
                annotation.coordinate = annotation.tempoCoordinate;
                annotation.tempoCoordinate = emptyCoordinate;
            }
            [mapView addAnnotations:[buildingClusters allObjects]];
            [mapView removeAnnotations:[toRemove allObjects]];
            
            mapView.userInteractionEnabled = YES;
//            dispatch_semaphore_signal(sema);
        }];
    }];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

@end
