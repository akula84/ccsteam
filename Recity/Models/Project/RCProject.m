//
//  RCProject.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject.h"

#import "RCPoint.h"
#import "RCTypeDetails.h"
#import "RCCity.h"
#import "RCAddress.h"
#import "RCMapController.h"

@interface RCProject ()

@property (strong, nonatomic) RCAddress *addressObject;

@end

@implementation RCProject

@synthesize addressObject = _addressObject;

- (BOOL)isSelected
{
    return [[RCMapController selectedProject].uid isEqualToNumber:self.uid];
}

- (NSArray *)developers {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.developersData];
    
    return [array isKindOfClass:[NSArray class]] ? array : nil;
}

- (NSArray *)architects {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.architectsData];
    
    return [array isKindOfClass:[NSArray class]] ? array : nil;
}

- (CLLocation *)centerLocation {
    CLLocation *result = [CLLocation new];
    if (self.centerPoint.latitude && self.centerPoint.longitude) {
        result = [[CLLocation alloc] initWithLatitude:self.centerPoint.latitude.doubleValue longitude:self.centerPoint.longitude.doubleValue];
    }
    return result;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.centerPoint.latitude.doubleValue, self.centerPoint.longitude.doubleValue);
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
            result = MGRColorWithHex(@"40748d");
            break;
            
        default:
            result = [UIColor clearColor];
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
            result = [UIColor lightGrayColor]; //MGRColorWithHex(@"0096DA");
            break;

        default:
            result = [UIColor clearColor];
            break;
    }
        
    return result;
}

- (ProjectStatus)projectStatus {
    NSString *projectStatus = self.status;
    ProjectStatus result = ProjectStatusUnknown;
    if (EQUAL(projectStatus, kPlanned)) {
        result = ProjectStatusPlanned;
    } else if (EQUAL(projectStatus, kCompleted)) {
        result = ProjectStatusCompleted;
    } else if (EQUAL(projectStatus, kUnderConstruction)) {
        result = ProjectStatusUnderConstruction;
    } else if (EQUAL(projectStatus, kUnannounced)) {
        result = ProjectStatusUnnannounced;
    }
    return result;
}

- (NSString *)mapPinImageNameForUser:(RCUser *)user {
    ProjectStatus projectStatus = [self projectStatus];
    NSString *result;
    BOOL isProjectFavorited = [user isItemFavoritedLocally:self];
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

- (NSString *)mapPinImageNameForCurrentUser
{
    return [self mapPinImageNameForUser:[AppState sharedInstance].user];
}

- (UIImage *)mapPinImageForUser:(RCUser *)user
{
    UIImage *result;
    NSString *imageName = [self mapPinImageNameForUser:user];
    if (imageName) {
        result = IMG(imageName);
    }
    return result;
}

- (UIImage *)mapPinImageForCurrentUser
{
    UIImage *result;
    NSString *imageName = [self mapPinImageNameForCurrentUser];
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

- (NSString *)constructionTypeText {
    NSString *result = self.constructionType;
    if ([result isEqualToString:@"NewConstruction"]) {
        result = @"New Construction";
    } else if ([result isEqualToString:@"RehabOrAddition"]) {
        result = @"Rehab / Addition";
    }
    return result;
}

- (BOOL)isMixedBuildingType {
    BOOL result;
    NSArray *buildingTypeStrings = [self buildingTypeStrings];
    result = buildingTypeStrings.count > 1;
    return result;
}
- (NSString *)buildingTypeTextIfNeedMixedUse
{
    NSString *text;
    if ([self isMixedBuildingType]) {
        text = @"Mixed Use";
    } else {
        text = [self buildingTypeText];
        if (!text.length) {
            text = kTBD;
        }
    }
    return text;
}

- (NSString *)buildingTypeText {
    NSString *result = [[self buildingTypeStrings] componentsJoinedByString:@", "];
    return result;
}

- (NSArray *)buildingTypeStrings {
    NSMutableArray *result = [@[]mutableCopy];
    if (self.typeDetails.residentialTbd.integerValue > 0) {
        [result addObject:@"Residential"];
    } else {
        if (self.typeDetails.apartments.integerValue > 0) {
            [result addObject:@"Apartments"];
        }
        if (self.typeDetails.condominiums.integerValue > 0) {
            [result addObject:@"Condominiums"];
        }
    }
    if (self.typeDetails.retail.integerValue > 0) {
        [result addObject:@"Retail"];
    }
    if (self.typeDetails.office.integerValue > 0) {
        [result addObject:@"Office"];
    }
    if (self.typeDetails.hotel.integerValue > 0) {
        [result addObject:@"Hotel"];
    }
    if (self.typeDetails.entertainment.integerValue > 0) {
        [result addObject:@"Entertainment"];
    }
    return result;
}

- (NSString *)statusString
{
    ProjectStatus projectStatus = [self projectStatus];
    NSString *status;
    switch (projectStatus) {
        case ProjectStatusUnderConstruction:
            status = @"Under Construction";
            break;
        case ProjectStatusCompleted:
            status = @"Recently Completed";
            break;
        default:
            status = self.status;
            break;
    }
    return status;
}

- (NSString *)extendedAddress
{
    NSMutableArray *extendedAddressParts = [NSMutableArray array];
    if (self.address.length > 0) {
        [extendedAddressParts addObject:self.address];
    }
    if (self.cityUID) {
        RCCity *cityOfThisProject = [RCCity MR_findFirstByAttribute:@"uid" withValue:self.cityUID inContext:[NSManagedObjectContext MR_defaultContext]];
        if (cityOfThisProject.cityNameWithState.length > 0) {
            NSString *appendingString = [NSString stringWithFormat:@"%@",cityOfThisProject.cityNameWithState];
            [extendedAddressParts addObject:appendingString];
        }
    }
    
    return [extendedAddressParts componentsJoinedByString:@", "];
}

- (NSString *)cityName
{
    NSString *name = @"";
    if (self.cityUID) {
        RCCity *cityOfThisProject = [RCCity MR_findFirstByAttribute:@"uid" withValue:self.cityUID inContext:[NSManagedObjectContext MR_defaultContext]];
        if (cityOfThisProject.cityNameWithState.length > 0) {
            name = [NSString stringWithFormat:@"%@",cityOfThisProject.cityNameWithState];
        }
    }
    return name;
}

- (RCAddress *)addressObject
{
    if (!_addressObject) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude == %@ and longitude == %@",
                                  self.centerPoint.latitude, self.centerPoint.longitude];
        
        RCAddress *address = [RCAddress MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
        if (!address) {
            address = [RCAddress MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            address.latitude = self.centerPoint.latitude;
            address.longitude = self.centerPoint.longitude;
            address.address = self.address;
            address.cityId = self.cityUID;
            address.developmentIndex = self.developmentIndex;
            [address.managedObjectContext MR_saveOnlySelfWithCompletion:nil];
        }
        _addressObject = address;
    }
    return _addressObject;
}

- (NSOrderedSet *)imagesSet
{
    return self.images;
}

@end
