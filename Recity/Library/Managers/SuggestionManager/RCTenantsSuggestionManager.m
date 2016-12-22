//
//  RCTenantsSuggestionManager.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTenantsSuggestionManager.h"
#import "RCSuggestionManager_Private.h"

#import "RCTenantsSuggestion.h"

#import "RCTenant.h"

@implementation RCTenantsSuggestionManager

- (void)setupSuggestionViewModels
{
    NSArray <RCTenant *> *tenants = self.project.tenants.allObjects;
    for(RCTenant *tenant in tenants) {
        RCSuggestionViewModel *tenantViewModel = [[RCSuggestionViewModel alloc] init];
        tenantViewModel.text = tenant.name;
        tenantViewModel.suggestionAction = RCNoneAction;
        tenantViewModel.cellID = @"tenants";
        [self.tmpViewModels addObject:tenantViewModel];
    }
    RCSuggestionViewModel *tenantWhichCanBeAdded = [[RCSuggestionViewModel alloc] init];
    tenantWhichCanBeAdded.image = [Utils circleImageWithRadius:17.5f
                                                   borderWidth:1.25f
                                                   borderColor:RGB(125, 125, 125)
                                                         image:IMG(@"will_add_suggestion")];
    tenantWhichCanBeAdded.cellID = @"addTenants";
    
    [self.tmpViewModels addObject:tenantWhichCanBeAdded];
}

- (void)addNewTenantViewModel:(RCSuggestionViewModel *)tenantViewModel
{
    //Inserted in the penultimate place
    [self.tmpViewModels insertObject:tenantViewModel
                             atIndex:(self.suggestionViewModels.count - 1)];
}

- (void)removeTenantViewModel:(RCSuggestionViewModel *)tenantViewModel
{
    [self.tmpViewModels removeObject:tenantViewModel];
}

- (RCProjectSuggestion *)suggestion
{
    NSMutableArray *tenantsDetail = [NSMutableArray array];
    for(RCSuggestionViewModel *suggestionModel in self.suggestionViewModels) {
        if(suggestionModel.suggestionAction != RCNoneAction &&
           suggestionModel.suggestionAction != RCNotValidAction) {
            RCTenantDetailSuggestion *tenantDetail = [[RCTenantDetailSuggestion alloc] initWithName:suggestionModel.text
                                                                                   tenantActionType:[suggestionModel stringForSuggestionAction]];
            [tenantsDetail addObject:tenantDetail];
        }
    }
    RCProjectSuggestion *result = nil;
    if(tenantsDetail.isFull) {
        result = [[RCTenantsSuggestion alloc] initWithProjectUID:self.project.uid
                                                   tenantsDetail:[tenantsDetail copy]];
    }
    return result;
}

@end
