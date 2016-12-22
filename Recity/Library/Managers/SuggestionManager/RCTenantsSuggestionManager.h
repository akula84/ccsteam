//
//  RCTenantsSuggestionManager.h
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionManager.h"

@interface RCTenantsSuggestionManager : RCSuggestionManager

- (void)addNewTenantViewModel:(RCSuggestionViewModel *)tenantViewModel;
- (void)removeTenantViewModel:(RCSuggestionViewModel *)tenantViewModel;

@end
