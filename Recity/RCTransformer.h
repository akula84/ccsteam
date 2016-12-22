//
//  RCTransformer.h
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProjectStatus) {
    ProjectStatusUnknown = 0,//     if has unknown value
    ProjectStatusPlanned = 1,
    ProjectStatusUnderConstruction = 2,
    ProjectStatusCompleted = 3,
    ProjectStatusUnnannounced = 4
};

typedef NS_ENUM(NSInteger, TenantType) {
    TenantTypeNone = 0,
    TenantTypeUnknown = 1,
    TenantTypeGrocery = 2,
    TenantTypeRestaurant= 3,
    TenantTypeCafe = 4,
    TenantTypeFitness = 5,
    TenantTypeServices = 6,
    TenantTypeRetailStore = 7,
    TenantTypeTheaterOrEntertainment = 8,
    TenantTypeConvenienceStore = 9,
    TenantTypeBank = 10,
    TenantTypeOffice = 11,
    TenantTypeHotel = 12,
    TenantTypeOther = 13
};

@interface RCTransformer : NSObject

+ (TenantType)tenantType:(NSString *)tenantType;
+ (NSString *)tenantTypeImageName:(TenantType)tenantType;
@end
