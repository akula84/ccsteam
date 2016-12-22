//
//  RCDevelopmentIndexNearbyProjectsViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexNearbyProjectsViewController.h"

#import "RCProjectDetail.h"
#import "RCProject.h"
#import "RCTenant.h"
#import "RCDetailsSection.h"
#import "RCAddress.h"
#import "RCFloatViewSliderController.h"
#import "FavoriteHelper.h"
#import "RCMapController.h"

@interface RCDevelopmentIndexNearbyProjectsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;

@property (strong, nonatomic) NSArray <RCProject *> *projects;

@end

@implementation RCDevelopmentIndexNearbyProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareTopView];
    [self prepareTableManager];
    
    self.tableManager.didSelectedCellWithItemBlock = ^(id item){
         [RCMapController showItem:item];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateBindings];
}

- (void)prepareTopView
{
    RCAddress *address = self.address;
    
    self.addressLabel.text = address.address;
    self.cityLabel.text = [address cityName];
    
    [FavoriteHelper checkFavorite:self.address favoriteButton:self.favoriteButton];
}

- (IBAction)favoriteButtonAction:(UIButton *)sender
{
    [FavoriteHelper favoriteAction:self.address favoriteButton:sender];
}

- (void)updateBindings
{
    [RCFloatViewSliderController setNoDetectTableView:self.tableManager.tableView];
}

- (void)prepareTableManager
{
    self.projects = [self cutArrayToLimit:[self.address nearbyProjectNotUnannounce]];
   
    RCDetailsSection *upcomingTenantsSection = [[RCDetailsSection alloc] init];
    upcomingTenantsSection.name = LOC(@"Nearby Upcoming Tenants");
    upcomingTenantsSection.type = DetailsSectionTypeUpcomingTenants;
    upcomingTenantsSection.items = @[];
    [self fillTenantsSection:upcomingTenantsSection];
    
    RCDetailsSection *nearbyDevelopmentsSection = [[RCDetailsSection alloc] init];
    nearbyDevelopmentsSection.name = LOC(@"Nearby Developments");
    nearbyDevelopmentsSection.type = DetailsSectionTypeNearbyDevelopments;
    nearbyDevelopmentsSection.items = self.projects;
    
    NSMutableArray *sections = [@[] mutableCopy];
    
    if (upcomingTenantsSection.items.count > 0) {
        [sections addObject:upcomingTenantsSection];
    }
    
    if (nearbyDevelopmentsSection.items.count > 0) {
        [sections addObject:nearbyDevelopmentsSection];
    }
    
    self.tableManager.sections = sections;
    
    self.noLabel.hidden = (upcomingTenantsSection.items.isFull || nearbyDevelopmentsSection.items.isFull);
}

- (void)fillTenantsSection:(RCDetailsSection *)section
{
    NSInteger row = 0;
    for (RCProject *project in self.projects) {
        if ([project projectStatus] != ProjectStatusCompleted) {
            for (NSUInteger i = 0; i < project.tenants.count; ++i) {
                RCTenant *tenant = [project.tenants allObjects][i];
                RCProjectDetail *detail = [[RCProjectDetail alloc] initWithTitle:tenant.name];
                TenantType tenantType = [RCTransformer tenantType:tenant.type];
                NSString *tenantImageName = [RCTransformer tenantTypeImageName:tenantType];
                if (tenantImageName) {
                    detail.image = IMG(tenantImageName);
                }
                detail.row = row;
                row ++;
                section.items = [section.items arrayByAddingObject:detail];
            }
        }
    }
    section.items = [self cutArrayToLimit:section.items];
}

- (NSArray *)cutArrayToLimit:(NSArray *)array
{
    NSRange range;
    range.location = 0;
    range.length = array.count > 10 ? 10 : array.count;
    return [array subarrayWithRange:range];
}

@end
