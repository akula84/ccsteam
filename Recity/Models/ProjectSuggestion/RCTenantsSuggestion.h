//
//  RCTenantSuggestion.h
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestion.h"

@interface RCTenantDetailSuggestion : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name
            tenantActionType:(NSString *)tenantActionType NS_DESIGNATED_INITIALIZER;

@end

@interface RCTenantsSuggestion : RCProjectSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
                     tenantsDetail:(NSArray <RCTenantDetailSuggestion *> *)tenantsDetail;

@end
