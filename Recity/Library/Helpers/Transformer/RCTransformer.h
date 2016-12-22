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

typedef NS_ENUM(NSUInteger, RCYearPeriod) {
    Early           = 3,
    Mid             = 6,
    Late            = 12,
    Spring          = 4,
    Summer          = 8,
    Fall            = 10,
    Winter          = 12,
    
    Q1              = 3,
    Q2              = 6,
    Q3              = 9,
    Q4              = 12,
    
    January         = 1,
    February        = 2,
    March           = 3,
    April           = 4,
    May             = 5,
    June            = 6,
    July            = 7,
    August          = 8,
    September       = 9,
    October         = 10,
    November        = 11,
    December        = 12,
    
    NoneYearPeriod  = 13
};

@interface RCTransformer : NSObject

+ (TenantType)tenantType:(NSString *)tenantType;
+ (NSString *)tenantTypeImageName:(TenantType)tenantType;

+ (NSString *)projectStatus:(ProjectStatus)status;

+ (RCYearPeriod)yearPeriodWithString:(NSString *)yearPeriodString;

@end
