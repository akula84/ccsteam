//
//  RCAddress+Parse.m
//  Recity
//
//  Created by Artem Kulagin on 28.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddress.h"

#import "RCPredicateFactory.h"
#import "RCDevelopmentIndexAPI.h"
#import "RCAddressApi.h"
#import "RCShareCoordinateUrlAPI.h"
#import "Utils.h"

@implementation RCAddress (Parse)

+ (instancetype)itemWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
    RCAddress *item = [RCAddress createAddressIfNeed:dict inContext:context];
    [item prepareValueWithDict:dict];
    
    return item;
}

- (void)prepareValueWithDict:(NSDictionary *)dict
{
    id address = dict[@"address"];
    if ((![address isEqual:[NSNull null]])) {
        self.address = address;
        self.placeName = address;
        self.formattedAddress = address;
    }
    self.latitude = [RCAddress latitudeFromDict:dict];
    self.longitude = [RCAddress longitudeFromDict:dict];
    
    self.city = dict[@"city"];
    NSString *formattedAddress = dict[@"formattedAddress"];
    if (formattedAddress) {
        self.formattedAddress = formattedAddress;
        self.address = formattedAddress;
    }
    self.formattedAddress = dict[@"formattedAddress"];
    
    NSString *placeName = dict[@"placeName"];
    if (placeName.isFull) {
        self.placeName = placeName;
    }
    NSString *zipCode = dict[@"zipCode"];
    if (zipCode.isFull) {
        self.zipCode = zipCode;
    }
}

+ (instancetype)createAddressIfNeed:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
    NSPredicate *pred = [self predCoordinate:dict];
    RCAddress *item = [RCAddress MR_findFirstWithPredicate:pred inContext:context];
    if (!item) {
        item = [RCAddress MR_createEntityInContext:context];
    }
    return item;
}

+ (NSPredicate *)predCoordinate:(NSDictionary *)dict
{
    return [RCPredicateFactory predAddressLatitude:[RCAddress latitudeFromDict:dict] longitude:[RCAddress longitudeFromDict:dict]];
}

+ (id)latitudeFromDict:(NSDictionary *)dict
{
    NSDictionary *coordinate = dict[@"coordinate"];
    return coordinate[@"latitude"];
}

+ (id)longitudeFromDict:(NSDictionary *)dict
{
    NSDictionary *coordinate = dict[@"coordinate"];
    return coordinate[@"longitude"];
}

- (void)downloadDevelopmentIndex:(completeAddressIndex)complete
{
    CLLocationCoordinate2D coordinate = [self coordinate];
    NSDictionary *parameters = @{@"latitude": @(coordinate.latitude),
                                 @"longitude": @(coordinate.longitude),
                                 };
    
    if (self.address.isFull) {
        [self downloadIndexWithComplete:complete];
    } else {
        [RCAddressApi withObject:parameters completion:^(id reply, NSError *error, BOOL *handleError) {
            if(error) {
                RUN_BLOCK(complete, nil, error);
            } else {
                if ([reply isKindOfClass:[NSDictionary class]]) {
                    [self prepareValueWithDict:reply];
                    [self downloadIndexWithComplete:complete];
                } else {
                    RUN_BLOCK(complete, nil, nil);
                }
            }
        }];
    }
}

- (void)downloadIndexWithComplete:(completeAddressIndex)complete
{
    CLLocationCoordinate2D coordinate = [self coordinate];
    NSDictionary *parameters = @{@"latitude": @(coordinate.latitude),
                                 @"longitude": @(coordinate.longitude)};
    if ([self isHaveIndexData] && self.saveDevelopmentIndex) {
        if(self.shareUrl.isFull) {
            [self.managedObjectContext MR_saveOnlySelfWithCompletion:nil];
            RUN_BLOCK(complete, self, nil);
        } else {
            [self downloadShareUrlWithComplete:complete];
        }
    } else {
        [RCDevelopmentIndexAPI withObject:parameters completion:^(id reply, NSError *error, BOOL *handleError) {
            if(error) {
                RUN_BLOCK(complete, nil, error);
            } else {
                self.developmentIndex = reply[@"changeScore"];
                self.overallInsightType = reply[@"overallInsightType"];
                NSDictionary *permitActivity = reply[@"permitActivity"];
                self.permitsOneToTwoYears = permitActivity[@"permitsOneToTwoYears"];
                self.permitsTwoToThreeYears = permitActivity[@"permitsTwoToThreeYears"];
                self.permitsZeroToOneYear = permitActivity[@"permitsZeroToOneYear"];
                
                [self downloadShareUrlWithComplete:complete];
            }
            
        }];
    }
}

- (void)downloadShareUrlWithComplete:(completeAddressIndex)complete
{
    [RCShareCoordinateUrlAPI withObject:@{kLatitude : self.latitude,
                                          kLongitude: self.longitude}
                             completion:^(id reply, NSError *error, BOOL *handleError)
     {
         if(error) {
             RUN_BLOCK(complete, nil, error);
         } else {
             self.shareUrl = reply[@"url"];
             [self.managedObjectContext MR_saveOnlySelfWithCompletion:nil];
             RUN_BLOCK(complete, self, nil);
         }
     }];
}

- (BOOL)isHaveIndexData
{
    return self.developmentIndex.isFull&&
            self.overallInsightType.isFull&&
            self.permitsOneToTwoYears.isFull&&
            self.permitsTwoToThreeYears.isFull&&
            self.permitsZeroToOneYear.isFull;
}

@end
