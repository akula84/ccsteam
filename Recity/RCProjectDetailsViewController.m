//
//  RCDevelopmentDetailsView.m
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController.h"
#import "RCDetailsHeaderView.h"
#import "RCInteractiveImageView.h"
#import "RCProject.h"
#import "RCImage.h"
#import "RCProjectDetail.h"
#import "RCTypeDetails.h"
#import "RCProjectDetailsTableManager.h"
#import "RCTenant.h"
#import "RCTransformer.h"

//@interface DetailsSection : NSObject
//
//@property (assign, nonatomic) DetailsSectionType type;
//@property (strong, nonatomic) NSArray *items;
//
//@end
//
//@implementation DetailsSection
//
//@end






@interface RCProjectDetailsViewController ()

@property (strong, nonatomic) NSArray *sections;

@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageMissedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *buildingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionDateLabel;

@property (strong, nonatomic) RCDetailsSection *developmentIndexSection;

@end

@implementation RCProjectDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftImageView.layer.masksToBounds = YES;
    
    RCProjectDetailsTableManager *tableManager = (RCProjectDetailsTableManager *)self.tableManager;
    @weakify(self);
    tableManager.didPressedProjectImageBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock,project);
    };
}

- (void)setProject:(RCProject *)project {
    _project = project;
    
//    NSLog(@"PROJECT SELECTED %@",project);
    
    self.sectionHeaderViewSample = [RCDetailsHeaderView loadFromNib];
    
    self.nameLabel.text = project.name;
    self.describingLabel.text = project.address;
    
    
    self.buildingTypeLabel.text = project.constructionType;
    
    NSDate *completionDate = [self completionDate:self.project.completionDate];
    NSString *completionQuarterDateString = [self quarterWithYearFromDate:completionDate];
    self.completionDateLabel.text = completionQuarterDateString;
    [self.leftImageView setImageWithURLstring:project.previewImage.url placeholderImage:IMG(@"project_preview_placeholder") imageMissedView:self.imageMissedLabel];
    @weakify(self);
    self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock, self.project);
    };
    
    BOOL favoritedAfter = [[AppState sharedInstance].user isProjectFavoritedLocally:self.project];
    [self displayAsFavorited:favoritedAfter];
    
    [self prepareTableManager];    
}

- (NSDate *)completionDate:(NSString *)completionDateString {
    NSDate *date = [NSDate dateFromString:completionDateString withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return date;
}

- (NSString *)quarterWithYearFromDate:(NSDate *)date {
    NSString *result = [date stringValueWithFormat:@"QQQ yyyy"];
    return result;
}
                             

- (void)prepareTableManager {
    
    RCDetailsSection *developmentDetailsSection = [[RCDetailsSection alloc] init];
    developmentDetailsSection.name = LOC(@"Development Details");
    developmentDetailsSection.type = DetailsSectionTypeDevelopmentDetails;
    developmentDetailsSection.items = @[];
    [self fillDevelopmentDetailsSection:developmentDetailsSection];
    
    RCDetailsSection *upcomingTenantsSection = [[RCDetailsSection alloc] init];
    upcomingTenantsSection.name = LOC(@"Upcoming tenants");
    upcomingTenantsSection.type = DetailsSectionTypeUpcomingTenants;
    upcomingTenantsSection.items = @[];
    [self fillTenantsSection:upcomingTenantsSection];
    
    RCDetailsSection *notesSection = [[RCDetailsSection alloc] init];
    notesSection.name = LOC(@"Notes");
    notesSection.type = DetailsSectionTypeNotes;
    notesSection.items = @[];
    
    self.developmentIndexSection = [[RCDetailsSection alloc] init];
    self.developmentIndexSection.name = LOC(@"Development Index");
    self.developmentIndexSection.type = DetailsSectionTypeDevelopmentIndex;
    self.developmentIndexSection.items = @[];
    [self fillDevelopmentIndexSection:self.developmentIndexSection];
    
    RCDetailsSection *nearbyDevelopmentsSection = [[RCDetailsSection alloc] init];
    nearbyDevelopmentsSection.name = LOC(@"Nearby Developments");
    nearbyDevelopmentsSection.type = DetailsSectionTypeNearbyDevelopments;
    NSArray *nearestProjects = [self.project nearestProjectsWithMaxDistanceAsHalfMileChoppedToCount:@(10)];
    nearbyDevelopmentsSection.items = nearestProjects;
    
    NSMutableArray *sections = [@[] mutableCopy];
    if (developmentDetailsSection.items.count > 0) {
        [sections addObject:developmentDetailsSection];
    }
    if (upcomingTenantsSection.items.count > 0) {
        [sections addObject:upcomingTenantsSection];
    }
    if (notesSection.items.count > 0) {
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

- (void)fillDevelopmentDetailsSection:(RCDetailsSection *)section {
//    NSLog(@"project uid %@",self.project.uid);
//    NSLog(@"status %@",self.project.status);
//    NSLog(@"constructionType %@",self.project.constructionType);
//    NSLog(@"numberOfResidentialUnits %@",self.project.typeDetails.numberOfResidentialUnits.stringValue);
//    NSLog(@"numberOfParkingSpaces %@",self.project.typeDetails.numberOfParkingSpaces);
//    NSLog(@"completionDate %@",self.project.completionDate);
//    NSLog(@"developers %@",self.project.developers);
//    NSLog(@"architect %@",self.project.architects);
    
    
    if (self.project.status.length > 0) {
        RCProjectDetail *status = [[RCProjectDetail alloc] initWithTitle:LOC(@"STATUS")];
        status.image = IMG(@"hammer_orange_small");
        status.describing = self.project.status;
        section.items = [section.items arrayByAddingObject:status];
    }
    if (self.project.constructionType.length > 0) {
        RCProjectDetail *constructionType = [[RCProjectDetail alloc] initWithTitle:LOC(@"BUILDING TYPE")];
        constructionType.image = [Utils image:IMG(@"table_bent_white_small") maskedByColor:kSmallIconOrangeColor];
        constructionType.describing = self.project.constructionType;
        section.items = [section.items arrayByAddingObject:constructionType];
    }
    if (self.project.typeDetails.estimatedNumberOfResidentialUnits.integerValue > 0) {
        RCProjectDetail *numberOfUnits = [[RCProjectDetail alloc] initWithTitle:LOC(@"NUMBER OF UNITS")];
        numberOfUnits.image = IMG(@"table_orange_small");
        numberOfUnits.describing = self.project.typeDetails.numberOfResidentialUnits.stringValue;
        section.items = [section.items arrayByAddingObject:numberOfUnits];
    }
    if (self.project.typeDetails.numberOfParkingSpaces.integerValue > 0) {
        RCProjectDetail *parking = [[RCProjectDetail alloc] initWithTitle:LOC(@"PARKING")];
        parking.image = IMG(@"car_orange_small");
        parking.describing = [NSString stringWithFormat:LOC(@"%@ Spaces"),self.project.typeDetails.numberOfParkingSpaces];
        section.items = [section.items arrayByAddingObject:parking];
    }
    if (self.project.completionDate > 0) {
        RCProjectDetail *completionDate = [[RCProjectDetail alloc] initWithTitle:LOC(@"EXPECTED COMPLETION")];
        completionDate.image = [Utils image:IMG(@"calendar_small") maskedByColor:kSmallIconOrangeColor];
        
        NSDate *expectedCompletionDate = [self completionDate:self.project.completionDate];
        NSString *completionQuarterDateString = [self quarterWithYearFromDate:expectedCompletionDate];
        completionDate.describing = completionQuarterDateString;
        section.items = [section.items arrayByAddingObject:completionDate];
    }
    if (self.project.developers.count > 0) {
        RCProjectDetail *developer = [[RCProjectDetail alloc] initWithTitle:LOC(@"DEVELOPER")];
        developer.image = IMG(@"warning_sign_orange_small");
        developer.describing = [self.project.developers componentsJoinedByString:@", "];
        section.items = [section.items arrayByAddingObject:developer];
    }
    if (self.project.architects.count > 0) {
        RCProjectDetail *architect = [[RCProjectDetail alloc] initWithTitle:LOC(@"ARCHITECT")];
        architect.image = IMG(@"measurer_orange_small");
        architect.describing = [self.project.architects componentsJoinedByString:@", "];
        section.items = [section.items arrayByAddingObject:architect];
    }
}

- (void)fillTenantsSection:(RCDetailsSection *)section {
    
    for (NSInteger i = 0; i < self.project.tenants.count; ++i) {
        RCTenant *tenant = [self.project.tenants allObjects][i];
        RCProjectDetail *detail = [[RCProjectDetail alloc] initWithTitle:tenant.name];
        TenantType tenantType = [RCTransformer tenantType:tenant.type];
        NSString *tenantImageName = [RCTransformer tenantTypeImageName:tenantType];
        if (tenantImageName) {
            detail.image = IMG(tenantImageName);
        }
        detail.row = i;
        section.items = [section.items arrayByAddingObject:detail];
    }
}

- (void)fillDevelopmentIndexSection:(RCDetailsSection *)section {
    RCProjectDetail *developmentIndex = [RCProjectDetail new];
    developmentIndex.title = @"...";
    section.items = [section.items arrayByAddingObject:developmentIndex];
    
    if (self.project) {
        [self.project downloadDevelopmentIndex].then(^(RCProject *project) {
            if (project.developmentIndex) {
                developmentIndex.title = project.developmentIndex.stringValue;
                if (self.developmentIndexSection.items.count > 0) {
                    NSArray *indexPaths = [self.tableManager indexPathsOfItem:[self.developmentIndexSection.items firstObject] inSections:@[self.developmentIndexSection]];
                    if (indexPaths.count) {
                        [self.tableManager reloadItemAtIndexPath:[indexPaths firstObject] animation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }).catch(^(NSError *error) {
            NSLog(@"ERROR %@",error.localizedDescription);
        });
    }
}

- (IBAction)favoriteAction {
    BOOL isFavorited = [[AppState sharedInstance].user isProjectFavoritedLocally:self.project];
    BOOL willFavorited = !isFavorited;
    [self displayAsFavorited:willFavorited];
    [[AppState sharedInstance].user setProject:self.project favoritedRemotely:willFavorited].finally(^{
        
    });
}

- (void)displayAsFavorited:(BOOL)favorited {
    if (favorited) {
        [self.favoriteButton setImage:IMG(@"favorite_orange_filled") forState:UIControlStateNormal];
        [self.favoriteButton setImage:IMG(@"favorite_orange_filled") forState:UIControlStateHighlighted];
    } else {
        [self.favoriteButton setImage:IMG(@"star_white_empty_medium") forState:UIControlStateNormal];
        [self.favoriteButton setImage:IMG(@"star_white_empty_medium") forState:UIControlStateHighlighted];
    }
}

- (void)scrollToProjectDetailsSection {
    [self scrollToSectionWithTypeIfExists:DetailsSectionTypeDevelopmentDetails];
}

- (void)scrollToNotesSection {
    [self scrollToSectionWithTypeIfExists:DetailsSectionTypeNotes];
}

- (void)scrollToNearestSection {
    [self scrollToSectionWithTypeIfExists:DetailsSectionTypeNearbyDevelopments];
}

- (void)scrollToSectionWithTypeIfExists:(DetailsSectionType)sectionType {
    NSArray *result = [self.tableManager.sections valueForKeyPath:@"type"];
    NSInteger index = [result indexOfObject:@(sectionType)];
    if (index != NSNotFound) {
        RCDetailsSection *section = (RCDetailsSection *)self.tableManager.sections[index];
        if (section.items.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            NSLog(@"");//
            [self.tableManager.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (BOOL)sectionWithTypeIsAvailable:(DetailsSectionType)sectionType {
    BOOL result = NO;
    NSArray *sectionTypes = [self.tableManager.sections valueForKeyPath:@"type"];
    NSInteger index = [sectionTypes indexOfObject:@(sectionType)];
    if (index != NSNotFound) {
        result = YES;
    }
    return result;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([self.detailSections count]) {
//        return self.detailSections.count;
//    }
//    return 1;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    RCDetailsHeaderView *result = [RCDetailsHeaderView loadFromNib];
//    DetailsSection *currentDetailsSection = self.detailSections[section];
//    result.textLabel.text = [RCProjectDetailsViewController detailsSectionName:currentDetailsSection.type];
//    return result;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    CGFloat result = self.sectionHeaderViewSample.height;
//    return result;
//}

//+ (NSString *)detailsSectionName:(DetailsSectionType)detailsSectionType {
//    NSString *result;
//    switch (detailsSectionType) {
//        case DetailsSectionTypeDevelopmentDetails:
//            result = LOC(@"Development Details");
//            break;
//            
//        case DetailsSectionTypeUpcomingTenants:
//            result = LOC(@"Upcoming tenants");
//            break;
//            
//        case DetailsSectionTypeNotes:
//            result = LOC(@"Notes");
//            break;
//            
//        case DetailsSectionTypeDevelopmentIndex:
//            result = LOC(@"Development Index");
//            break;
//            
//        case DetailsSectionTypeNearbyDevelopments:
//            result = LOC(@"Nearby Developments");
//            break;
//            
//        default:
//            break;
//    }
//    return result;
//}

@end
