//
//  RCTransformer.m
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTransformer.h"

@implementation RCTransformer

/*
 
 TenantTypeUnknown = 0,
 TenantTypeGrocery = 1,
 TenantTypeRestaurant= 2,
 TenantTypeCafe = 3,
 TenantTypeFitness = 4,
 TenantTypeServices = 5,
 TenantTypeRetailStore = 6,
 TenantTypeTheaterOrEntertainment = 7,
 TenantTypeConvenienceStore = 8,
 TenantTypeBank = 9,
 TenantTypeOffice = 10,
 TenantTypeHotel = 11,
 TenantTypeOther = 12
 
 */

+ (TenantType)tenantType:(NSString *)tenantType {
    NSString *lowercaseTenantType = [tenantType lowercaseString];
    TenantType result = TenantTypeNone;
    if (EQUAL(lowercaseTenantType, @"unknown")) {
        result = TenantTypeUnknown;
    } else if (EQUAL(lowercaseTenantType, @"grocery")) {
        result = TenantTypeGrocery;
    } else if (EQUAL(lowercaseTenantType, @"restaurant")) {
        result = TenantTypeRestaurant;
    } else if (EQUAL(lowercaseTenantType, @"cafe")) {
        result = TenantTypeCafe;
    } else if (EQUAL(lowercaseTenantType, @"fitness")) {
        result = TenantTypeFitness;
    } else if (EQUAL(lowercaseTenantType, @"services")) {
        result = TenantTypeServices;
    } else if (EQUAL(lowercaseTenantType, @"retailstore")) {
        result = TenantTypeRetailStore;
    } else if (EQUAL(lowercaseTenantType, @"theaterorentertainment")) {
        result = TenantTypeTheaterOrEntertainment;
    } else if (EQUAL(lowercaseTenantType, @"conveniencestore")) {
        result = TenantTypeConvenienceStore;
    } else if (EQUAL(lowercaseTenantType, @"bank")) {
        result = TenantTypeBank;
    } else if (EQUAL(lowercaseTenantType, @"office")) {
        result = TenantTypeOffice;
    } else if (EQUAL(lowercaseTenantType, @"hotel")) {
        result = TenantTypeHotel;
    } else if (EQUAL(lowercaseTenantType, @"other")) {
        result = TenantTypeOther;
    }
    return result;
}

+ (NSString *)tenantTypeImageName:(TenantType)tenantType {
    NSString *result;
    switch (tenantType) {
        case TenantTypeUnknown:{
            result = @"unknown";
        }break;
            
        case TenantTypeGrocery:{
            result = @"grocery";
            
        }break;
            
        case TenantTypeRestaurant:{
            result = @"cafe";
        }break;
            
        case TenantTypeCafe:{
            result = @"cafe";
        }break;
            
        case TenantTypeFitness:{
            result = @"fitness";
        }break;
            
        case TenantTypeServices:{
            result = @"other";
        }break;
            
        case TenantTypeRetailStore:{
            result = @"retail_store";
        }break;
            
        case TenantTypeTheaterOrEntertainment:{
            result = @"entertainment";
        }break;
            
        case TenantTypeConvenienceStore:{
            result = @"convenience_store";
        }break;
            
        case TenantTypeBank:{
            result = @"bank";
        }break;
            
        case TenantTypeOffice:{
            result = @"office";
        }break;
            
        case TenantTypeHotel:{
            result = @"hotel";
        }break;
            
        case TenantTypeOther:{
            result = @"other";
        }break;
            
        default:
            break;
    }
    return result;
}

+ (NSString *)projectStatus:(ProjectStatus)status {
    NSString *result = nil;
    switch (status) {
        case ProjectStatusUnknown:
            result = @"Unknown";
            break;
        case ProjectStatusPlanned:
            result = kPlanned;
            break;
        case ProjectStatusUnderConstruction:
            result = kUnderConstruction;
            break;
        case ProjectStatusCompleted:
            result = kCompleted;
            break;
        case ProjectStatusUnnannounced:
            result = @"Unnannounced";
        default:
            break;
    }
    return result;
}

+ (RCYearPeriod)yearPeriodWithString:(NSString *)yearPeriodString
{
    RCYearPeriod result = NoneYearPeriod;
    if (EQUAL(yearPeriodString, @"Early")) {
        result = Early;
    } else if (EQUAL(yearPeriodString, @"Mid")) {
        result = Mid;
    } else if (EQUAL(yearPeriodString, @"Late")) {
        result = Late;
    } else if (EQUAL(yearPeriodString, @"Spring")) {
        result = Spring;
    } else if (EQUAL(yearPeriodString, @"Summer")) {
        result = Summer;
    } else if (EQUAL(yearPeriodString, @"Fall")) {
        result = Fall;
    } else if (EQUAL(yearPeriodString, @"Winter")) {
        result = Winter;
    } else if (EQUAL(yearPeriodString, @"Q1")) {
        result = Q1;
    } else if (EQUAL(yearPeriodString, @"Q2")) {
        result = Q2;
    } else if (EQUAL(yearPeriodString, @"Q3")) {
        result = Q3;
    } else if (EQUAL(yearPeriodString, @"Q4")) {
        result = Q4;
    } else if (EQUAL(yearPeriodString, @"January")) {
        result = January;
    } else if (EQUAL(yearPeriodString, @"February")) {
        result = February;
    } else if (EQUAL(yearPeriodString, @"March")) {
        result = March;
    } else if (EQUAL(yearPeriodString, @"April")) {
        result = April;
    } else if (EQUAL(yearPeriodString, @"May")) {
        result = May;
    } else if (EQUAL(yearPeriodString, @"June")) {
        result = June;
    } else if (EQUAL(yearPeriodString, @"July")) {
        result = July;
    } else if (EQUAL(yearPeriodString, @"August")) {
        result = August;
    } else if (EQUAL(yearPeriodString, @"September")) {
        result = September;
    } else if (EQUAL(yearPeriodString, @"October")) {
        result = October;
    } else if (EQUAL(yearPeriodString, @"November")) {
        result = November;
    } else if (EQUAL(yearPeriodString, @"December")) {
        result = December;
    }
    return result;
}

@end
