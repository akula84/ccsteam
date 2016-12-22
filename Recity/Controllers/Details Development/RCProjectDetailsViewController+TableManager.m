//
//  RCProjectDetailsViewController+TableManager.m
//  Recity
//
//  Created by Artem Kulagin on 16.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"

#import "RCProjectDetail.h"
#import "RCProject.h"
#import "RCTypeDetails.h"
#import "RCTenant.h"
#import "RCAddress.h"
#import "RCUserNotes.h"

@implementation RCProjectDetailsViewController (TableManager)

- (void)prepareTableManager
{
    RCDetailsSection *developmentDetailsSection = [[RCDetailsSection alloc] init];
    developmentDetailsSection.name = LOC(@"Development Details");
    developmentDetailsSection.type = DetailsSectionTypeDevelopmentDetails;
    developmentDetailsSection.items = @[];
    [self fillDevelopmentDetailsSection:developmentDetailsSection];
    
    RCDetailsSection *suggestAnEditSection = [[RCDetailsSection alloc] init];
    suggestAnEditSection.name = LOC(@"Suggest an edit");
    suggestAnEditSection.type = DetailsSectionTypeSuggestAnEdit;
    suggestAnEditSection.items = @[@"suggestAnEdit"];
    suggestAnEditSection.isShowHeader = NO;
    
    RCDetailsSection *upcomingTenantsSection = [[RCDetailsSection alloc] init];
    upcomingTenantsSection.name = LOC(kUpcomingtenants);
    upcomingTenantsSection.type = DetailsSectionTypeUpcomingTenants;
    upcomingTenantsSection.items = @[];
    [self fillTenantsSection:upcomingTenantsSection];
    
    RCDetailsSection *notesSection = [[RCDetailsSection alloc] init];
    notesSection.name = LOC(@"Notes");
    notesSection.type = DetailsSectionTypeNotes;
    notesSection.items = @[self.project];
    
    self.developmentIndexSection = [[RCDetailsSection alloc] init];
    self.developmentIndexSection.name = LOC(@"Development Index");
    self.developmentIndexSection.type = DetailsSectionTypeDevelopmentIndex;
    self.developmentIndexSection.items = @[];
    [self fillDevelopmentIndexSection:self.developmentIndexSection];
    
    RCDetailsSection *nearbyDevelopmentsSection = [[RCDetailsSection alloc] init];
    nearbyDevelopmentsSection.name = LOC(@"Nearby Developments");
    nearbyDevelopmentsSection.type = DetailsSectionTypeNearbyDevelopments;
    NSArray *nearestProjects = [self.project nearbyProjectsWithMaxDistanceAsHalfMileChoppedToCount:kMaximumNearbyProjectCountForDisplaying];
    nearbyDevelopmentsSection.items = nearestProjects;
    
    NSMutableArray *sections = [@[] mutableCopy];
    if (developmentDetailsSection.items.count > 0) {
        [sections addObject:developmentDetailsSection];
    }
    if(suggestAnEditSection.items.count > 0) {
        [sections addObject:suggestAnEditSection];
    }
    if (upcomingTenantsSection.items.count > 0 && self.project.projectStatus != ProjectStatusCompleted) {
        [sections addObject:upcomingTenantsSection];
    }
    if(notesSection.items.count > 0) {
        [sections addObject:notesSection];
    }
    if (self.developmentIndexSection.items.count > 0) {
        [sections addObject:self.developmentIndexSection];
    }
    if (nearbyDevelopmentsSection.items.count > 0) {
        [sections addObject:nearbyDevelopmentsSection];
    }
    
    self.tableManager.sections = sections;
}

- (void)fillDevelopmentDetailsSection:(RCDetailsSection *)section
{
    BOOL advanced = [AppState advancedVersion];
    
    if (self.project.status.length > 0) {
        RCProjectDetail *status = [[RCProjectDetail alloc] initWithTitle:LOC(@"STATUS")];
        status.image = IMG(@"hammer_orange_small");
        status.describing = [self.project statusString];
        section.items = [section.items arrayByAddingObject:status];
    }
    NSString *buildingTypeText = [self.project buildingTypeText];
    if (buildingTypeText.length > 0) {
        RCProjectDetail *buildingType = [[RCProjectDetail alloc] initWithTitle:LOC(@"BUILDING TYPE")];
        buildingType.image = [Utils image:IMG(@"table_bent_white_small") maskedByColor:kSmallIconOrangeColor];
        buildingType.describing = buildingTypeText;
        section.items = [section.items arrayByAddingObject:buildingType];
    }
    NSString *constructionTypeText = [self.project constructionTypeText];
    if (constructionTypeText.length > 0 && advanced) {
        RCProjectDetail *constructionType = [[RCProjectDetail alloc] initWithTitle:LOC(@"CONSTRUCTION TYPE")];
        constructionType.image = [Utils image:IMG(@"table_bent_white_small") maskedByColor:kSmallIconOrangeColor];
        constructionType.describing = constructionTypeText;
        section.items = [section.items arrayByAddingObject:constructionType];
    }
    if (self.project.typeDetails.numberOfResidentialUnits.integerValue > 0) {
        RCProjectDetail *numberOfUnits = [[RCProjectDetail alloc] initWithTitle:LOC(@"NUMBER OF UNITS")];
        numberOfUnits.image = IMG(@"table_orange_small");
        numberOfUnits.describing = self.project.typeDetails.numberOfResidentialUnits.stringValue;
        section.items = [section.items arrayByAddingObject:numberOfUnits];
    }
    if (self.project.floorCount.integerValue > 0 && advanced) {
        RCProjectDetail *numberOfFloors = [[RCProjectDetail alloc] initWithTitle:LOC(@"NUMBER OF FLOORS")];
        numberOfFloors.image = IMG(@"table_orange_small");
        numberOfFloors.describing = self.project.floorCount.stringValue;
        section.items = [section.items arrayByAddingObject:numberOfFloors];
    }
    if (self.project.typeDetails.numberOfParkingSpaces.integerValue > 0) {
        RCProjectDetail *parking = [[RCProjectDetail alloc] initWithTitle:LOC(@"PARKING")];
        parking.image = IMG(@"car_orange_small");
        parking.describing = [NSString stringWithFormat:LOC(@"%@ Spaces"),self.project.typeDetails.numberOfParkingSpaces];
        section.items = [section.items arrayByAddingObject:parking];
    }
    if (self.project.developers.count > 0) {
        RCProjectDetail *developer = [[RCProjectDetail alloc] initWithTitle:LOC(@"DEVELOPER")];
        developer.image = IMG(@"warning_sign_orange_small");
        developer.describing = [self.project.developers componentsJoinedByString:@", "];
        section.items = [section.items arrayByAddingObject:developer];
    }
    if (self.project.architects.count > 0 && advanced) {
        RCProjectDetail *architect = [[RCProjectDetail alloc] initWithTitle:LOC(@"ARCHITECT")];
        architect.image = IMG(@"measurer_orange_small");
        architect.describing = [self.project.architects componentsJoinedByString:@", "];
        section.items = [section.items arrayByAddingObject:architect];
    }
    if ([self.project isHaveGroundbreaking] && advanced) {
        RCProjectDetail *groundbreakingDetail = [[RCProjectDetail alloc] initWithTitle:LOC(@"GROUNDBREAKING")];
        groundbreakingDetail.image = [Utils image:IMG(@"hammer_orange_small") maskedByColor:kSmallIconOrangeColor];
        
        groundbreakingDetail.describing = [self.project groundbreakingDateString];
        section.items = [section.items arrayByAddingObject:groundbreakingDetail];
    }
    {
        NSString *completionTitle = [self completionCellLabelText];
        RCProjectDetail *completionDate = [[RCProjectDetail alloc] initWithTitle:LOC(completionTitle)];
        completionDate.image = [Utils image:IMG(@"calendar_small") maskedByColor:kSmallIconOrangeColor];
        
        completionDate.describing = [self.project completionTimeWithYear];
        section.items = [section.items arrayByAddingObject:completionDate];
    }
}

- (void)fillTenantsSection:(RCDetailsSection *)section
{
    for (NSUInteger i = 0; i < self.project.tenants.count; ++i) {
        RCTenant *tenant = [self.project.tenants allObjects][i];
        RCProjectDetail *detail = [[RCProjectDetail alloc] initWithTitle:tenant.name];
        TenantType tenantType = [RCTransformer tenantType:tenant.type];
        NSString *tenantImageName = [RCTransformer tenantTypeImageName:tenantType];
        if (tenantImageName) {
            detail.image = IMG(tenantImageName);
        }
        detail.row = (NSInteger)i;
        section.items = [section.items arrayByAddingObject:detail];
    }
}

- (void)fillDevelopmentIndexSection:(RCDetailsSection *)section
{
    RCProjectDetail *developmentIndex = [RCProjectDetail new];
    
    developmentIndex.title = self.project.developmentIndex ? self.project.developmentIndex.stringValue : @"...";
    developmentIndex.address = [self.project addressObject];
    section.items = [section.items arrayByAddingObject:developmentIndex];
    if (self.project) {
        [self.project.addressObject downloadDevelopmentIndex:^(RCAddress *address, NSError *error) {
            if (address.developmentIndex) {
                developmentIndex.title = address.developmentIndex.stringValue;
                if (self.developmentIndexSection.items.count > 0) {
                    NSArray *indexPaths = [self.tableManager indexPathsOfItem:[self.developmentIndexSection.items firstObject]
                                                                   inSections:@[self.developmentIndexSection]];
                    if (indexPaths.count) {
                        [self.tableManager reloadItemAtIndexPath:[indexPaths firstObject]
                                                       animation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }];
    }
}

- (NSString *)completionCellLabelText
{
    NSString *result;
    if ([self.project projectStatus] == ProjectStatusCompleted) {
        result = @"COMPLETION DATE";
    } else {
        result = @"EXPECTED COMPLETION";
    }
    return result;
}

@end
