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

@end
