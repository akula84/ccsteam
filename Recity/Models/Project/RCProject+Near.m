//
//  RCProject+Near.m
//  Recity
//
//  Created by Artem Kulagin on 16.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject.h"

#import "RCPredicateFactory.h"
#import "RCPoint.h"
#import "NSNumber+CLLocationDistance.h"

@implementation RCProject (Near)

- (NSArray<RCProject *> *)nearbyProjectsWithMaxDistanceAsHalfMileChoppedToCount:(nullable NSNumber *)countLimit {
    NSArray *resultSortedByAscending;
    CLLocationCoordinate2D selfProjectPoint = [self centerLocation].coordinate;
    resultSortedByAscending = [RCProject nearbyProjectsToPoint:selfProjectPoint maxDistanceAsHalfMileChoppedToCount:countLimit];
    NSPredicate *pred =  [NSCompoundPredicate notPredicateWithSubpredicate:[RCPredicateFactory predUid:self.uid]];
    return [resultSortedByAscending filteredArrayUsingPredicate:pred];
}

+ (NSArray<RCProject *> *)nearbyProjectsToPoint:(CLLocationCoordinate2D)sourcePoint maxDistanceAsHalfMileChoppedToCount:(NSNumber *)countLimit {
    return [self nearbyProjectsToPoint:sourcePoint maxDistanceAsHalfMileChoppedToCount:countLimit willChop:YES];
}

+ (NSArray<RCProject *> *)nearbyProjectsToPoint:(CLLocationCoordinate2D)sourcePoint
{
    return [self nearbyProjectsToPoint:sourcePoint maxDistanceAsHalfMileChoppedToCount:@(0) willChop:NO];
}

+ (NSArray<RCProject *> *)nearbyProjectsToPoint:(CLLocationCoordinate2D)sourcePoint  maxDistanceAsHalfMileChoppedToCount:(NSNumber *)countLimit willChop:(BOOL)willChop
{
    NSArray *resultSortedByAscending;
    CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:sourcePoint.latitude longitude:sourcePoint.longitude];
    CLLocationDistance maxDistance = [@(500) milesToKm].doubleValue;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(RCProject * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:evaluatedObject.centerPoint.latitude.doubleValue longitude:evaluatedObject.centerPoint.longitude.doubleValue];
        
        return [location distanceFromLocation:pointLocation] <= maxDistance;
    }];
    
    NSArray *array = [RCProject MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
    
    resultSortedByAscending = [filtered sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RCProject *project1 = (RCProject *)obj1;
        RCProject *project2 = (RCProject *)obj2;
        CLLocationCoordinate2D point1 = [project1 centerLocation].coordinate;
        CLLocationCoordinate2D point2 = [project2 centerLocation].coordinate;
        
        CLLocationDistance project1ToPointDistance = [RCProject distanceBetweenPoint1:point1 point2:sourcePoint];
        CLLocationDistance project2ToPointDistance = [RCProject distanceBetweenPoint1:point2 point2:sourcePoint];
        return project2ToPointDistance < project1ToPointDistance;
    }];
    
    BOOL countCut = willChop && countLimit && ((NSInteger)resultSortedByAscending.count > countLimit.integerValue);
    if (countCut) {
        resultSortedByAscending = [resultSortedByAscending subarrayWithRange:NSMakeRange(0, (NSUInteger)countLimit.integerValue)];
    }
    
    return resultSortedByAscending;
}

+ (CLLocationDistance)distanceBetweenPoint1:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2 {
    CLLocationDistance result;
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:point2.latitude longitude:point2.longitude];
    result = [location1 distanceFromLocation:location2];
    return result;
}

- (CLLocationDistance)distanceBetweenPoint:(CLLocationCoordinate2D)point
{
    return [RCProject distanceBetweenPoint1:[self coordinate] point2:point];
}

@end
