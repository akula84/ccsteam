//
//  RCProject.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject.h"
#import "RCImage.h"
#import "RCPoint.h"
#import "RCShape.h"
#import "RCTypeDetails.h"

@implementation RCProject

+ (PMKPromise *)loadAllProjects {
    
    RCBaseRequest *registration = ({
        RCBaseRequest *request = [RCBaseRequest new];
        request.methodString = @"GET";
        request.methodName = @"GetProjects";
        request.objectMapping = [self objectMapping];
        
        request;
    });
    
//    void (^checkProjects)() = ^{
//        NSArray *projects = [RCProject MR_findAll];
//        NSLog(@"%@", @(projects.count));
//    };
//    checkProjects();
    return [[RCHTTPSessionManager shared] loadRequest:registration].then(^(NSArray <RCProject *> *array) {
        return array;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), checkProjects);
    });
}

+ (NSArray<RCProject *> *)nearestToPoint:(CLLocationCoordinate2D)point {
    NSArray *array = [RCProject MR_findAll];
    
    NSArray *filtered = [array filteredArrayUsingPredicate:({
        [self nearestPredicateWithPoint:point];
    })];
    
    return filtered;
}

+ (NSPredicate *)nearestPredicateWithPoint:(CLLocationCoordinate2D)point {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(RCProject * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CLLocationDistance maxDistance = 500 / 0.621371192;
        CLLocation *location = [[CLLocation alloc]initWithLatitude:evaluatedObject.centerPoint.latitude.doubleValue longitude:evaluatedObject.centerPoint.longitude.doubleValue];
        CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
        return [location distanceFromLocation:pointLocation] <= maxDistance;
    }];
    return predicate;
}

- (NSArray<RCProject *> *)nearestProjectsWithMaxDistanceAsHalfMileChoppedToCount:(nullable NSNumber *)countLimit {
    CLLocationCoordinate2D selfProjectPoint = [self centerLocation].coordinate;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(RCProject * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CLLocationDistance maxDistance = 500 / 0.621371192;//       half mile
        CLLocation *location = [[CLLocation alloc]initWithLatitude:evaluatedObject.centerPoint.latitude.doubleValue longitude:evaluatedObject.centerPoint.longitude.doubleValue];
        CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:selfProjectPoint.latitude longitude:selfProjectPoint.longitude];
        return [location distanceFromLocation:pointLocation] <= maxDistance;
    }];
    
    NSArray *array = [RCProject MR_findAll];
    
    NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
    NSArray *sortedByAscending = [filtered sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RCProject *project1 = (RCProject *)obj1;
        RCProject *project2 = (RCProject *)obj2;
        CLLocationCoordinate2D point1 = [project1 centerLocation].coordinate;
        CLLocationCoordinate2D point2 = [project2 centerLocation].coordinate;
        
        CLLocationDistance project1ToPointDistance = [RCProject distanceBetweenPoint1:point1 point2:selfProjectPoint];
        CLLocationDistance project2ToPointDistance = [RCProject distanceBetweenPoint1:point2 point2:selfProjectPoint];
        return project2ToPointDistance < project1ToPointDistance;
    }];
    
//    for (NSInteger i = 0; i < sortedByAscending.count; ++i) {
//        RCProject *currentProject = sortedByAscending[i];
//        CLLocationCoordinate2D currentProjectPoint = [currentProject centerLocation].coordinate;
//        NSLog(@"nearest sortered by distance ascending %@ %@",currentProject.uid,@([RCProject distanceBetweenPoint1:currentProjectPoint point2:selfProjectPoint]));
//    }
    
    BOOL willChop = countLimit && (sortedByAscending.count > countLimit.integerValue);
    if (willChop) {
        sortedByAscending = [sortedByAscending subarrayWithRange:NSMakeRange(0, countLimit.integerValue)];
    }
    
    return sortedByAscending;
}

+ (CLLocationDistance)distanceBetweenPoint1:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2 {
    CLLocationDistance result;
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:point2.latitude longitude:point2.longitude];
    result = [location1 distanceFromLocation:location2];
    return result;
}

+ (NSArray<RCProject *> *)projectsWithCoordinateTopLeft:(CLLocationCoordinate2D)topLeft rightBottom:(CLLocationCoordinate2D)rightBottom {
    NSArray *filtered = [RCProject MR_findAllWithPredicate:({
        [self predicateForProjectsWithCoordinateTopLeft:topLeft rightBottom:rightBottom];
    })];
    
    return filtered;
}

+ (NSPredicate *)predicateForProjectsWithCoordinateTopLeft:(CLLocationCoordinate2D)topLeft rightBottom:(CLLocationCoordinate2D)rightBottom {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%@ <= longitude) AND (longitude <= %@)"
                              @"AND (%@ <= latitude) AND (latitude <= %@)",
                              @(topLeft.longitude), @(rightBottom.longitude), @(rightBottom.latitude), @(topLeft.latitude)];
    return predicate;
}

#pragma mark - Mappings

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:({
            @[
              @"status",
              @"name",
              @"address",
              @"constructionType",
              @"completionTime",
              @"completionDate",
              @"buildingSize",
              @"estimatedBuildingSize",
              @"landSize",
              @"estimatedFloorCount",
              @"floorCount",
              ];
        })];
        [mapping mapKeyPath:@"id" toProperty:@"uid"];
        [mapping mapKeyPath:@"developers" toProperty:@"developersData" withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:value]];
            return data;
        }];
        [mapping mapKeyPath:@"architects" toProperty:@"architectsData" withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:value]];
            return data;
        }];
    
        [mapping hasMany:[RCImage class] forKeyPath:@"images"];
        [mapping hasMany:[RCShape class] forKeyPath:@"shapes"];
        [mapping hasMany:[RCTenant class] forKeyPath:@"tenants"];
        [mapping hasOne:[RCPoint class] forKeyPath:@"centerPoint"];
        [mapping hasOne:[RCImage class] forKeyPath:@"previewImage"];
        [mapping hasOne:[RCTypeDetails class] forKeyPath:@"typeDetails"];
        
        [mapping setPrimaryKey:@"uid"];
    }];
}

+ (EKManagedObjectMapping *)developmentIndexMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapKeyPath:@"changeScore" toProperty:@"developmentIndex"];
    }];
}

#pragma mark - Utils

- (NSArray *)developers {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.developersData];
    
    return [array isKindOfClass:[NSArray class]] ? array : nil;
}

- (NSArray *)architects {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.architectsData];
    
    return [array isKindOfClass:[NSArray class]] ? array : nil;
}

- (CLLocation *)centerLocation {
    CLLocation *result;
    if (self.centerPoint.latitude && self.centerPoint.longitude) {
        result = [[CLLocation alloc] initWithLatitude:self.centerPoint.latitude.doubleValue longitude:self.centerPoint.longitude.doubleValue];
    }
    return result;
}

- (PMKPromise *)downloadDevelopmentIndex {
    RCBaseRequest *developmentIndex = ({
        RCBaseRequest *request = [RCBaseRequest new];
        request.methodString = @"GET";
        request.methodName = @"GetGeoCoordinateChangeScore";
        request.objectMapping = [RCProject developmentIndexMapping];
        CLLocationCoordinate2D coordinate = [self centerLocation].coordinate;
        request.parameters = ({
            @{
              @"latitude": @(coordinate.latitude),
              @"longitude": @(coordinate.longitude),
            };
        });
        request;
    });
    
    return [[RCHTTPSessionManager shared] loadRequest:developmentIndex].then(^(id mappedObject) {
        return mappedObject;
    });
}

- (UIColor *)borderColorForCurrentStatus {
    UIColor *result;
    ProjectStatus status = [self projectStatus];
    switch (status) {
        case ProjectStatusPlanned:
            result = MGRColorWithHex(@"00476B");
            break;
            
        case ProjectStatusUnderConstruction:
            result = MGRColorWithHex(@"9D2924");
            break;
            
        case ProjectStatusCompleted:
            result = MGRColorWithHex(@"185712");
            break;
            
        case ProjectStatusUnnannounced:
            result = MGRColorWithHex(@"00476B");
            break;
            
        default:
            break;
    }
    return result;
}

- (UIColor *)colorForCurrentStatus {
    UIColor *result;
    ProjectStatus status = [self projectStatus];
    switch (status) {
        case ProjectStatusPlanned:
            result = MGRColorWithHex(@"0096DA");
            break;

        case ProjectStatusUnderConstruction:
            result = MGRColorWithHex(@"D60B31");
            break;

        case ProjectStatusCompleted:
            result = MGRColorWithHex(@"30AD24");
            break;

        case ProjectStatusUnnannounced:
            result = MGRColorWithHex(@"0096DA");
            break;

        default:
            break;
    }
    return result;
}

- (ProjectStatus)projectStatus {
    NSString *projectStatus = self.status;
    ProjectStatus result = ProjectStatusUnknown;
    if (EQUAL(projectStatus, @"Planned")) {
        result = ProjectStatusPlanned;
    } else if (EQUAL(projectStatus, @"Completed")) {
        result = ProjectStatusCompleted;
    } else if (EQUAL(projectStatus, @"UnderConstruction")) {
        result = ProjectStatusUnderConstruction;
    } else if (EQUAL(projectStatus, @"Unannounced")) {
        result = ProjectStatusUnnannounced;
    }
    return result;
}

- (NSString *)mapPinImageNameForUser:(RCUser *)user {
    ProjectStatus projectStatus = [self projectStatus];
    NSString *result;
    BOOL isProjectFavorited = [user isProjectFavoritedLocally:self];
    switch (projectStatus) {
        case ProjectStatusPlanned:{
            if (isProjectFavorited) {
                result = @"star_blue";
            } else {
                result = @"round_blue";
            }
        }break;
            
        case ProjectStatusUnderConstruction:{
            if (isProjectFavorited) {
                result = @"star_red";
            } else {
                result = @"round_red";
            }
        }break;
            
        case ProjectStatusCompleted:{
            if (isProjectFavorited) {
                result = @"star_green";
            } else {
                result = @"round_green";
            }
        }break;
            
        case ProjectStatusUnnannounced:{
            if (isProjectFavorited) {
                result = @"star_blue";
            } else {
                result = @"round_blue";
            }
        }break;
            
        default:
            break;
    }
    return result;
}

- (UIImage *)mapPinImageForUser:(RCUser *)user {
    UIImage *result;
    NSString *imageName = [self mapPinImageNameForUser:user];
    if (imageName) {
        result = IMG(imageName);
    }
    return result;
}

- (NSString *)projectStatusMarkerImageName {
    NSString *result;
    ProjectStatus projectStatus = [self projectStatus];
    switch (projectStatus) {
        case ProjectStatusPlanned:{
            result = @"round_blue";
        }break;
            
        case ProjectStatusUnderConstruction:{
            result = @"round_red";
            
        }break;
            
        case ProjectStatusCompleted:{
            result = @"round_green";
        }break;
            
        case ProjectStatusUnnannounced:{
            result = @"round_blue";
        }break;
            
        default:
            break;
    }
    return result;
}

@end
