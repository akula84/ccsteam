//
//  RCProject.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

@import CoreLocation;

@class RCImage, RCShape, RCTypeDetails, RCPoint;

NS_ASSUME_NONNULL_BEGIN

@interface RCProject : RCBaseModel

+ (PMKPromise *)loadAllProjects;

- (CLLocation *)centerLocation;
+ (NSArray <RCProject *> *)nearestToPoint:(CLLocationCoordinate2D)point;
- (NSArray<RCProject *> *)nearestProjectsWithMaxDistanceAsHalfMileChoppedToCount:(nullable NSNumber *)countLimit;

+ (NSPredicate *)nearestPredicateWithPoint:(CLLocationCoordinate2D)point;
+ (NSPredicate *)predicateForProjectsWithCoordinateTopLeft:(CLLocationCoordinate2D)topLeft rightBottom:(CLLocationCoordinate2D)rightBottom;

- (NSArray *)developers;
- (NSArray *)architects;

- (PMKPromise *)downloadDevelopmentIndex;
- (UIColor *)borderColorForCurrentStatus;
- (UIColor *)colorForCurrentStatus;

- (ProjectStatus)projectStatus;
- (NSString *)mapPinImageNameForUser:(RCUser *)user;
- (UIImage *)mapPinImageForUser:(RCUser *)user;
- (NSString *)projectStatusMarkerImageName;

@end

NS_ASSUME_NONNULL_END

#import "RCProject+CoreDataProperties.h"
