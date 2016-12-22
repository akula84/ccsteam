//
//  RCLocationAddress.h
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import "RCBaseModel.h"

@class RCDevelopmentIndexMetricModel;

@interface RCAddress : RCBaseModel

@property (assign, nonatomic) BOOL saveDevelopmentIndex;

- (BOOL)isSelected;
- (BOOL)isSearchResult;
- (NSString *)placeNameIsHave;
- (NSString *)cityName;
- (CLLocationCoordinate2D)coordinate;

- (NSArray <RCDevelopmentIndexMetricModel *> *)metricsModel;
- (void)reloadMetrics;

- (NSArray *)nearbyProject;
- (NSArray *)nearbyProjectNotUnannounce;
- (NSArray *)nearbyTenProjectNotUnannounce;
- (BOOL)isEqualAddress:(RCAddress *)item;

@end

@interface RCAddress (Parse)

typedef void (^completeAddressIndex) (RCAddress *address, NSError *error);
- (void)downloadDevelopmentIndex:(completeAddressIndex)complete;
+ (instancetype)itemWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end


#import "RCAddress+CoreDataProperties.h"
