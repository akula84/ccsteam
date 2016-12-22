//
//  RCSelectionSuggestionManager.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSelectionSuggestionManager.h"
#import "RCSuggestionManager_Private.h"

@implementation RCSelectionSuggestionManager

- (void)setupSuggestionViewModels
{
    RCSuggestionViewModel *developmentStatus = [[RCSuggestionViewModel alloc] init];
    developmentStatus.image = [Utils image:IMG(@"hammer_orange_small") maskedByColor:[UIColor whiteColor]];
    developmentStatus.text = @"Development Status";
    developmentStatus.cellID = @"Development Status";
    
    RCSuggestionViewModel *developmentTenants = [[RCSuggestionViewModel alloc] init];
    developmentTenants.image = [Utils image:IMG(@"convenience_store") maskedByColor:[UIColor whiteColor]];
    developmentTenants.text = @"Development Tenants";
    developmentTenants.cellID = @"Development Tenants";
    
    RCSuggestionViewModel *other = [[RCSuggestionViewModel alloc] init];
    other.image = [Utils image:IMG(@"other") maskedByColor:[UIColor whiteColor]];
    other.text = @"Other";
    other.cellID = @"Other";
    
    [self.tmpViewModels addObjectsFromArray:@[developmentStatus,
                                              developmentTenants,
                                              other]];
}

@end
