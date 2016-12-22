//
//  RCLocationAddress.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddress.h"

#import "RCDIMetricModels.h"
#import "RCProject.h"
#import "RCPredicateFactory.h"
#import "RCCity.h"
#import "RCMapController.h"
#import "RCSearchManager.h"

@interface RCAddress()

@property (strong, nonatomic, readonly) NSArray<RCDevelopmentIndexMetricModel *> *metricsModel;
@property (strong, nonatomic, readonly) NSArray *nearbyProject;
@property (strong, nonatomic, readonly) NSArray *nearbyProjectNotUnannounced;

@end

@implementation RCAddress

@synthesize nearbyProjectNotUnannounced = _nearbyProjectNotUnannounced;
@synthesize saveDevelopmentIndex = _saveDevelopmentIndex;

- (BOOL)isSearchResult
{
    id resultItem = [RCSearchManager resultItem];
    BOOL isSearchResult = NO;
    if ([resultItem isKindOfClass:[RCAddress class]]) {
        isSearchResult = [self isEqualAddress:resultItem];
    }
    return isSearchResult;
}

- (BOOL)isSelected
{
    RCAddress *selectedAddress = [self selectedAddress];
    BOOL equal = [self isSelectedEqualAddress];
    if (![selectedAddress.address isFull]&&![self.address isFull]) {
        equal = [self isSelectedEqualObject];
    }
    return equal;
}

- (BOOL)isSelectedEqualAddress
{
    return [self isEqualAddress:[self selectedAddress]];
}

- (BOOL)isEqualAddress:(RCAddress *)item
{
    return (self.latitude.doubleValue == item.latitude.doubleValue)&&
            (self.longitude.doubleValue == item.longitude.doubleValue);
}

- (BOOL)isSelectedEqualObject
{
    return [self selectedAddress] == self;
}

- (instancetype)selectedAddress
{
    return [RCMapController selectedAddress];
}

- (NSArray *)nearbyProjectNotUnannounce
{
    if (!_nearbyProjectNotUnannounced) {
        
        NSPredicate *predUnannounced = [RCPredicateFactory predUnannounced];
        NSPredicate *predNotUnannounced  = [NSCompoundPredicate notPredicateWithSubpredicate:predUnannounced];
        _nearbyProjectNotUnannounced = [[self nearbyProject] filteredArrayUsingPredicate:predNotUnannounced];
    }
    return _nearbyProjectNotUnannounced;
}

- (NSArray *)nearbyTenProjectNotUnannounce
{
    return [RCProject nearbyProjectsToPoint:[self coordinate] maxDistanceAsHalfMileChoppedToCount:@(10)];
}

@synthesize nearbyProject = _nearbyProject;

- (NSArray *)nearbyProject
{
    if (!_nearbyProject) {
        _nearbyProject = [RCProject nearbyProjectsToPoint:[self coordinate]];
    }
    return _nearbyProject;
}

- (NSString *)placeNameIsHave
{
    NSString *placeName = self.placeName;
    if (!placeName.isFull) {
        placeName = self.address;
    }
    return placeName;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (NSString *)cityName
{
    NSString *name = @"";
    if (!self.cityId.integerValue) {
        RCCity *city = [[AppState  sharedInstance] currentCity];
        self.cityId = city ? city.uid : @(1);
    }
    
    RCCity *cityOfThisProject = [RCCity MR_findFirstByAttribute:@"uid" withValue:self.cityId inContext:[NSManagedObjectContext MR_defaultContext]];
    if (cityOfThisProject.cityNameWithState.length > 0) {
        name = [NSString stringWithFormat:@"%@",cityOfThisProject.cityNameWithState];
    }
    
    return name;
}

@synthesize metricsModel = _metricsModel;

- (NSArray<RCDevelopmentIndexMetricModel *> *)metricsModel
{
    if (!_metricsModel) {
        _metricsModel = @[[RCDIMetricModelNearbyTypes modelWithTitle:@"Nearby Project Types"],
                          [RCDIMetricModelFootageByStatus modelWithTitle:@"Total Square Footage by Status"],
                          [RCPlannedTimelineMetric modelWithTitle:@"New Projects Timeline"],
                          [RCAreaPermitMetric modelWithTitle:@"Area Permit Activity"],
                          [RCCondosApartmentsMetric modelWithTitle:@"Condos vs Apartments"],
                          [RCNewResidentialMetric modelWithTitle:@"New Residential Units by Status"],
                          [RCNewRetailMetric modelWithTitle:@"New Retail by Status"],
                          [RCNewOfficeMetric modelWithTitle:@"New Office by Status"]];
        for (RCDevelopmentIndexMetricModel *model in _metricsModel) {
            model.address = self;
        }
    }
    return _metricsModel;
}

- (void)reloadMetrics
{
    _nearbyProject = nil;
    _nearbyProjectNotUnannounced = nil;
    _metricsModel = nil;
}

@end
