//
//  RCProject.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

#define kMaximumNearbyProjectCountForDisplaying     @(10)

@import CoreLocation;

@class RCImage, RCShape, RCTypeDetails, RCPoint, RCAddress;

NS_ASSUME_NONNULL_BEGIN

@interface RCProject : RCBaseModel

- (RCAddress *)addressObject;

- (NSString *)extendedAddress;
- (NSString *)cityName;

- (CLLocationCoordinate2D)coordinate;
- (CLLocation *)centerLocation;
- (nullable NSArray *)developers;
- (nullable NSArray *)architects;

- (UIColor *)borderColorForCurrentStatus;
- (UIColor *)colorForCurrentStatus;

- (ProjectStatus)projectStatus;
- (nullable NSString *)mapPinImageNameForUser:(RCUser *)user;
- (nullable UIImage *)mapPinImageForCurrentUser;
- (nullable NSString *)projectStatusMarkerImageName;
- (NSString *)constructionTypeText;
- (NSString *)buildingTypeText;
- (NSString *)buildingTypeTextIfNeedMixedUse;
- (NSString *)statusString;

- (BOOL)isSelected;

@end

@interface RCProject (Near)

- (NSArray<RCProject *> *)nearbyProjectsWithMaxDistanceAsHalfMileChoppedToCount:(nullable NSNumber *)countLimit;
+ (NSArray<RCProject *> *)nearbyProjectsToPoint:(CLLocationCoordinate2D)sourcePoint;
+ (NSArray<RCProject *> *)nearbyProjectsToPoint:(CLLocationCoordinate2D)sourcePoint maxDistanceAsHalfMileChoppedToCount:(NSNumber *)countLimit;
+ (CLLocationDistance)distanceBetweenPoint1:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2;
- (CLLocationDistance)distanceBetweenPoint:(CLLocationCoordinate2D)point;

@end

@interface RCProject (Date)

- (NSDate *)expectedCompletionDate;
- (BOOL)isHaveGroundbreaking;
- (NSString *)groundbreakingDateString;
- (NSString *)completionTimeWithYear;
- (NSInteger)completionYear;

@end


NS_ASSUME_NONNULL_END

#import "RCProject+CoreDataProperties.h"
