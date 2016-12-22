//
//  RCProjectDetailsTableManager.m
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsTableManager.h"
#import "RCDetailsSection.h"
#import "RCProjectDetailsCell.h"
#import "RCProjectTenantCell.h"
#import "RCDevelopmentIndexCell.h"
#import "RCNearbyProjectCell.h"
#import "RCProjectDetail.h"
#import "RCDetailsHeaderView.h"

@implementation RCProjectDetailsTableManager

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUseSeparatorsZeroInset:YES];
}

- (NSString *)headerIdentifierForSection:(RCTableSection *)section {
    return [RCDetailsHeaderView rc_className];
}

- (void)configureHeaderView:(UIView *)view forSection:(RCTableSection *)section {
    RCDetailsHeaderView *headerView = (RCDetailsHeaderView *)view;
    headerView.textLabel.text = section.name;
}

- (CGFloat)heightForHeaderViewOfSection:(RCTableSection *)section {
    return 66;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    NSString *result;
    RCDetailsSection *section = (RCDetailsSection *)self.sections[indexPath.section];
    switch (section.type) {
        case DetailsSectionTypeDevelopmentDetails:
            result = [RCProjectDetailsCell rc_className];
            break;

        case DetailsSectionTypeUpcomingTenants:
            result = [RCProjectTenantCell rc_className];
            break;

//        case DetailsSectionTypeNotes:
//            result = [RCProjectDetailsCell rc_className];//!!!!!
//            break;

        case DetailsSectionTypeDevelopmentIndex:
            result = [RCDevelopmentIndexCell rc_className];
            break;

        case DetailsSectionTypeNearbyDevelopments:
            result = [RCNearbyProjectCell rc_className];
            break;

            
        default:
            break;
    }
    return result;
}

- (NSArray *)cellNibNames {
    return @[[RCProjectDetailsCell rc_className],
             [RCProjectTenantCell rc_className],
//             [RCProjectDetailsCell rc_className],!!!!!!!!!!
             [RCDevelopmentIndexCell rc_className],
             [RCNearbyProjectCell rc_className],
             ];
}

- (void)configureCell:(RCBaseTableCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    RCDetailsSection *section = (RCDetailsSection *)self.sections[indexPath.section];
//    NSLog(@"section type %@",@(section.type));
//    NSIndexPath *indexPath = [self indexPathByItem:item];
    switch (section.type) {
        case DetailsSectionTypeDevelopmentDetails: {
            RCProjectDetailsCell *detailsCell = (RCProjectDetailsCell *)cell;
            detailsCell.detail = item;
        }
        break;

        case DetailsSectionTypeUpcomingTenants: {
            RCProjectTenantCell *detailsCell = (RCProjectTenantCell *)cell;
            detailsCell.detail = item;
        }
        break;

        case DetailsSectionTypeDevelopmentIndex: {
            RCDevelopmentIndexCell *detailsCell = (RCDevelopmentIndexCell *)cell;
            detailsCell.detail = item;
        }
        break;
            
        case DetailsSectionTypeNearbyDevelopments: {
            RCNearbyProjectCell *detailsCell = (RCNearbyProjectCell *)cell;
            detailsCell.project = item;
            
            @weakify(self);
            detailsCell.didPressedProjectImageBlock = ^(RCProject *project) {
                @strongify(self);
                RUN_BLOCK(self.didPressedProjectImageBlock,project);
            };
        }
            break;
            
        default:
            break;
    }
    cell.contentViewInsets = UIEdgeInsetsMake(0, 26, 0, 0);
}

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = YES;
    RCDetailsSection *section = (RCDetailsSection *)self.sections[indexPath.section];
    if (section.type == DetailsSectionTypeDevelopmentDetails
        || section.type == DetailsSectionTypeUpcomingTenants
        || section.type == DetailsSectionTypeDevelopmentIndex) {
        result = NO;
    }
    return  result;
}

@end
