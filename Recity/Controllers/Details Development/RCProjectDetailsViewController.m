//
//  RCDevelopmentDetailsView.m
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController.h"
#import "RCProjectDetailsViewController_Private.h"

#import "RCDetailsHeaderView.h"
#import "RCProjectDetailsTableManager.h"
#import "RCInteractiveImageView.h"
#import "CGRect+Utils.h"
#import "FavoriteHelper.h"
#import "RCToolbarController.h"
#import "RCFloatViewSliderController.h"
#import "RCSuggestionTypeTableViewController.h"
#import "RCDetailController.h"
#import "RCMapController.h"
#import "RCProjectDetail.h"

#import "RCSuggestionTypeTableViewController.h"
#import "RCBaseNavigationController.h"
#import "RCSizeHelper.h"

@interface RCProjectDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIView *tableHeader;

@end

@implementation RCProjectDetailsViewController

- (void)updateBindings
{
    [RCFloatViewSliderController  setNoDetectTableView:[self tableManager].tableView];
    [self prepareDetailController];
    [self prepareToolbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.leftImageView.layer.masksToBounds = YES;
    
    self.didSelectedItemBlock = ^(id object) {
         if ([object isKindOfClass:[RCProject class]]) {
            [RCDetailController scrollToProjectDetailsSection];
            [RCMapController showItem:object];
            [RCFloatViewSliderController displayHalfscreen];
        } else if ([object isKindOfClass:[RCProjectDetail class]]) {
            RCProjectDetail *detail = (RCProjectDetail *)object;
            if (detail.address) {
                [RCDetailController scrollToProjectDetailsSection];
                [RCMapController showItem:detail.address];
            }
        }
    };
    
    [self setupCheckVisibleSectionType];
    
    [self prepareHeightTableHeader];
    [self reloadViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self prepareUserNotesHandler];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self cleanUserNotesHandler];
    
    [super viewDidDisappear:animated];
}

- (void)setupCheckVisibleSectionType
{
    ((RCProjectDetailsTableManager *)self.tableManager).checkVisibleSectionType = ^(DetailsSectionType visibleSectionType) {
        [RCDetailController selectSectionWithType:visibleSectionType];
    };
}

- (void)prepareToolbar
{
    [RCToolbarController switchToolbarToState:RCMapToolbarViewStateDetails];
    [RCDetailController resetSelectionSection];
    [RCDetailController selectSectionWithType:DetailsSectionTypeDevelopmentDetails];
}

- (void)prepareHeightTableHeader
{
    CGFloat height  = [RCSizeHelper detailsHalfHeight] - CGRectGetHeight(self.titleView.frame);
    UIView *tableHeader = self.tableHeader;
    tableHeader.frame = CGRectSetHeight(tableHeader.frame,height);
}

- (void)reloadViews
{
    [self prepareSpinner];
    
    self.sectionHeaderViewSample = [RCDetailsHeaderView loadFromNib];
    
    [self prepareTopView];
    [self prepareShortDataView];
    [self prepareLeftImageView];
    [self prepareTableManager];
}

- (IBAction)centerProjectOnMapAction
{
    [RCFloatViewSliderController displayFullscreen];
    [RCDetailController selectSectionWithType:DetailsSectionTypeDevelopmentDetails];
}

- (IBAction)favoriteAction
{
    [FavoriteHelper favoriteAction:self.project favoriteButton:self.favoriteButton];
}

- (IBAction)showSuggestAnEdit
{
    RCSuggestionTypeTableViewController *suggestTypeVC = [RCSuggestionTypeTableViewController instantiateFromStoryboardNamed:@"SuggestAnEdit"];
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    [suggestTypeVC configureSuggestionManagerCreatorWithProject:self.project];
    [nav slideLayerInDirection:direction_top andPush:suggestTypeVC];
}

- (void)scrollToProjectDetailsSection
{
    [(RCProjectDetailsTableManager *)self.tableManager scrollToSectionWithTypeIfExists:DetailsSectionTypeDevelopmentDetails];
}

- (void)scrollToNotesSection
{
    [(RCProjectDetailsTableManager *)self.tableManager scrollToSectionWithTypeIfExists:DetailsSectionTypeNotes];
}

- (void)scrollToNearestSection
{
    [(RCProjectDetailsTableManager *)self.tableManager scrollToSectionWithTypeIfExists:DetailsSectionTypeNearbyDevelopments];
}

- (BOOL)sectionWithTypeIsAvailable:(DetailsSectionType)sectionType
{
    BOOL result = NO;
    NSArray *sectionTypes = [self.tableManager.sections valueForKeyPath:@"type"];
    NSUInteger index = [sectionTypes indexOfObject:@(sectionType)];
    if (index != NSNotFound) {
        result = YES;
    }
    return result;
}

@end
