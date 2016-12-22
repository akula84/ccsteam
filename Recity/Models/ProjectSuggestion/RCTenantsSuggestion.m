//
//  RCTenantSuggestion.m
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTenantsSuggestion.h"

#import "RCTenant.h"

@interface RCTenantDetailSuggestion ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSString *tenantActionType;

@end

@implementation RCTenantDetailSuggestion

- (instancetype)initWithName:(NSString *)name
            tenantActionType:(NSString *)tenantActionType {
    if(self = [super init]) {
        _name = [name copy];
        _tenantActionType = tenantActionType;
    }
    return self;
}

- (NSDictionary *)parametrsOfTenantDetail {
    return @{@"name" : _name,
             kSuggestionType : self.tenantActionType};
}


- (BOOL)isEqual:(RCTenantDetailSuggestion *)object {
    if(self == object) return YES;
    
    if([self.name isEqualToString:object.name] &&
       self.tenantActionType == object.tenantActionType)
        return YES;
    
    return NO;
}

@end

@interface RCTenantsSuggestion ()

@property (copy, nonatomic) NSArray <RCTenantDetailSuggestion *> *tenantsDetail;

@end

@implementation RCTenantsSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
                     tenantsDetail:(NSArray<RCTenantDetailSuggestion *> *)tenantsDetail
{
    if(self = [super initWithProjectUID:projectUID]) {
        _tenantsDetail = tenantsDetail;
    }
    return self;
}

- (NSDictionary *)parametersOfSuggestion {
    NSMutableArray *result = [NSMutableArray array];
    for(RCTenantDetailSuggestion *tenantDetail in self.tenantsDetail) {
        [result addObject:[tenantDetail parametrsOfTenantDetail]];
    }
    return @{kProjectId : self.projectUID,
             kSuggestionType : @"tenants",
             kTenantsSuggestion : [result copy]};
}

@end
