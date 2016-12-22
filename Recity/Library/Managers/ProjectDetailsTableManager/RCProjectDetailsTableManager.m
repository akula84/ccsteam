//
//  RCProjectDetailsTableManager.m
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsTableManager.h"

#import "RCProjectDetailsCell.h"
#import "RCSuggestAnEditCell.h"
#import "RCProjectTenantCell.h"
#import "RCUserNotesCell.h"
#import "RCDevelopmentIndexCell.h"
#import "RCNearbyProjectCell.h"
#import "RCProjectDetail.h"
#import "RCDetailsHeaderView.h"

@implementation RCProjectDetailsTableManager

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUseSeparatorsZeroInset:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.f;
    RCDetailsSection *section = (RCDetailsSection *)self.sections[(NSUInteger)indexPath.section];
    id item = [self itemByIndexPath:indexPath];
    
    switch (section.type) {
        case DetailsSectionTypeDevelopmentDetails:
            height = [RCProjectDetailsCell height:item];
            break;
        case DetailsSectionTypeNearbyDevelopments:
            height = [RCNearbyProjectCell height:item];
            break;
        case DetailsSectionTypeNotes: {
            height = [RCUserNotesCell height:item];
            break;
        }
        default:
            break;
    }
    return height;
}

- (NSString *)headerIdentifierForSection:(RCTableSection *)section
{
    return [RCDetailsHeaderView rc_className];
}

- (void)configureHeaderView:(UIView *)view forSection:(RCTableSection *)section
{
    RCDetailsHeaderView *headerView = (RCDetailsHeaderView *)view;
    headerView.textLabel.text = section.name;
}

- (CGFloat)heightForHeaderViewOfSection:(RCTableSection *)section
{
    CGFloat height = 66.f;
    NSString *name = section.name;
    if ([name isEqualToString:kUpcomingtenants]) {
        height = 111.f;
    }
    
    if ([name isEqualToString:kNearbyDevelopments]) {
        height = 90.f;
    }
    
    return height;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    NSString *result;
    RCDetailsSection *section = (RCDetailsSection *)self.sections[(NSUInteger)indexPath.section];
    switch (section.type) {
        case DetailsSectionTypeDevelopmentDetails:
            result = [RCProjectDetailsCell rc_className];
            break;
        case DetailsSectionTypeSuggestAnEdit:
            result = [RCSuggestAnEditCell rc_className];
            break;
        case DetailsSectionTypeUpcomingTenants:
            result = [RCProjectTenantCell rc_className];
            break;
        case DetailsSectionTypeNotes:
            result = [RCUserNotesCell rc_className];
            break;
        case DetailsSectionTypeDevelopmentIndex:
            result = [RCDevelopmentIndexCell rc_className];
            break;
        case DetailsSectionTypeNearbyDevelopments:
            result = [RCNearbyProjectCell rc_className];
            break;
    }
    return result;
}

- (NSArray *)cellNibNames {
    return @[[RCProjectDetailsCell rc_className],
             [RCSuggestAnEditCell rc_className],
             [RCProjectTenantCell rc_className],
             [RCUserNotesCell rc_className],
             [RCDevelopmentIndexCell rc_className],
             [RCNearbyProjectCell rc_className]];
}

- (void)configureCell:(RCBaseTableCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    RCDetailsSection *section = (RCDetailsSection *)self.sections[(NSUInteger)indexPath.section];
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
            
        case DetailsSectionTypeNotes: {
            RCUserNotesCell *detailsCell = (RCUserNotesCell *)cell;
            detailsCell.userNotes = [RCUserNotes userNotesForProject:item];
        }
        break;
            
        case DetailsSectionTypeNearbyDevelopments: {
            RCNearbyProjectCell *detailsCell = (RCNearbyProjectCell *)cell;
            detailsCell.project = item;
        }
        break;
            
        default:
            break;
    }
    cell.contentViewInsets = UIEdgeInsetsMake(0, kCellInsets, 0, 0);
}

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = YES;
    RCDetailsSection *section = (RCDetailsSection *)self.sections[(NSUInteger)indexPath.section];
    if (section.type == DetailsSectionTypeDevelopmentDetails
        || section.type == DetailsSectionTypeSuggestAnEdit
        || section.type == DetailsSectionTypeUpcomingTenants
        || section.type == DetailsSectionTypeNotes) {
        result = NO;
    }
    return  result;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging || scrollView.decelerating) {
        DetailsSectionType selectedSectionType;
        if([self developmentDetailsSectionIsVisible]) {
            selectedSectionType = DetailsSectionTypeDevelopmentDetails;
        } else if([self nearbySectionIsVisible]) {
            selectedSectionType = DetailsSectionTypeNearbyDevelopments;
        } else {
            selectedSectionType = DetailsSectionTypeNotes;
        }
        RUN_BLOCK(self.checkVisibleSectionType, selectedSectionType);
    }
}

- (BOOL)developmentDetailsSectionIsVisible
{
    CGFloat needYInContentViewForNotesSection = [self topYInContentViewForNotesSection] + 66.f;
    return needYInContentViewForNotesSection > [self bottomYWithContentOffsetForTableView];
}

- (BOOL)nearbySectionIsVisible
{
    BOOL result = NO;
    CGFloat topYInContentViewForNearbyDevelopmentsSection = [self topYInContentViewForNearbyDevelopmentsSection];
    if(topYInContentViewForNearbyDevelopmentsSection > 0.0) {
        CGFloat needYInContentViewForNearbyDevelopmentsSection = topYInContentViewForNearbyDevelopmentsSection + 66.f;
        result = needYInContentViewForNearbyDevelopmentsSection < [self bottomYWithContentOffsetForTableView];
    }
    return result;
}

- (CGRect)rectForDevelopmentDetailsSection
{
    return [self rectForSection:DetailsSectionTypeDevelopmentDetails];
}

- (CGRect)rectForSuggestAnEditSection
{
    return [self rectForSection:DetailsSectionTypeSuggestAnEdit];
}

- (CGRect)rectForUpcomingTenantsSection
{
    return [self rectForSection:DetailsSectionTypeUpcomingTenants];
}

- (CGRect)rectForNoteSection
{
    return [self rectForSection:DetailsSectionTypeNotes];
}

- (CGRect)rectForDevelopmentIndexSection
{
    return [self rectForSection:DetailsSectionTypeDevelopmentIndex];
}

- (CGRect)rectForNearbyDevelopmentsSection
{
    return [self rectForSection:DetailsSectionTypeNearbyDevelopments];
}

- (CGRect)rectForSection:(DetailsSectionType)sectionType
{
    CGRect result = CGRectZero;
    NSInteger indexForSection = [self indexForSection:sectionType];
    if(indexForSection != NSNotFound) {
        result = [self.tableView rectForSection:indexForSection];
    }
    return result;
}

- (NSInteger)indexForSection:(DetailsSectionType)sectionType
{
    NSArray *result = [self.sections valueForKeyPath:@"type"];
    NSUInteger index = [result indexOfObject:@(sectionType)];
    return (NSInteger)index;
}

- (CGFloat)topYInContentViewForNotesSection
{
    return [self rectForNoteSection].origin.y;
}

- (CGFloat)bottomYInContentViewForNotesSection
{
    CGRect rectForNotesSection = [self rectForNoteSection];
    return rectForNotesSection.origin.y + rectForNotesSection.size.height;
}

- (CGFloat)topYInContentViewForNearbyDevelopmentsSection
{
    CGRect rectForNearbyDevelopmentsSection = [self rectForNearbyDevelopmentsSection];
    return rectForNearbyDevelopmentsSection.origin.y;
}

- (CGFloat)topYWithContentOffsetForTableView
{
    return self.tableView.contentOffset.y;
}

- (CGFloat)bottomYInContentViewForDevelopmentIndexSection
{
    CGRect rectForDevelopmentIndexSection = [self rectForDevelopmentIndexSection];
    return rectForDevelopmentIndexSection.origin.y + rectForDevelopmentIndexSection.size.height;
}

- (CGFloat)bottomYWithContentOffsetForTableView
{
    return (self.tableView.contentOffset.y + self.tableView.bounds.size.height);
}

- (CGPoint)contentOffsetForNearbyDevelopmentSection
{
    CGPoint result;
    CGRect rectForNearbyDevelomentsSection = [self rectForNearbyDevelopmentsSection];
    if(CGRectIsEmpty(rectForNearbyDevelomentsSection)) {
        result = CGPointMake(0.0, [self bottomYInContentViewForDevelopmentIndexSection]);
    } else {
        result = rectForNearbyDevelomentsSection.origin;
    }
    return result;
}

- (void)scrollToSectionWithTypeIfExists:(DetailsSectionType)sectionType
{
    switch (sectionType) {
        case DetailsSectionTypeDevelopmentDetails: {
            [self.tableView setContentOffset:CGPointZero animated:YES];
            break;
        }
        case DetailsSectionTypeNotes: {
            CGPoint contentOffsetForNearbyDevelopmentSection = [self contentOffsetForNearbyDevelopmentSection];
            CGPoint contentOffsetForUserNotesSection = CGPointMake(contentOffsetForNearbyDevelopmentSection.x,
                                                                   contentOffsetForNearbyDevelopmentSection.y - self.tableView.height);
            [self.tableView setContentOffset:contentOffsetForUserNotesSection animated:YES];
            break;
        }
        case DetailsSectionTypeNearbyDevelopments: {
            [self scrollToSectionWithTypeIfExists:DetailsSectionTypeNearbyDevelopments
                                         animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)scrollToSectionWithTypeIfExists:(DetailsSectionType)sectionType
                               animated:(BOOL)animated
{
    NSInteger index = [self indexForSection:sectionType];
    RCDetailsSection *sectionForType = [self sectionWithType:sectionType];
    if(sectionForType) {
        [self scrollToSection:sectionForType
             withIndexSection:index
                     animated:animated];
    }
}

- (void)scrollToSection:(RCDetailsSection*)section
       withIndexSection:(NSInteger)index
               animated:(BOOL)animated
{
    if (section.items.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:animated];
    }
}

- (RCDetailsSection *)sectionWithType:(DetailsSectionType)sectionType
{
    NSInteger index = [self indexForSection:sectionType];
    RCDetailsSection *section = nil;
    if (index != NSNotFound) {
        section = (RCDetailsSection *)self.sections[(NSUInteger)index];
    }
    return section;
}

@end
