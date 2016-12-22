//
//  RCFiltersTableViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 30.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFiltersTableViewController.h"

#import "RCFilterManager.h"
#import "RCFilterMultiSelectController.h"
#import "RCFilterDateSelector.h"
#import "RCBaseNavigationController.h"
#import "RCMapViewController.h"
#import "RCFilterBaseCell.h"
#import "RCMapController.h"

@interface RCFiltersTableViewController () <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, RCFilterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *resetFiltersButton;

@end

@implementation RCFiltersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBar];
}

- (void)setupNavBar
{
    UIImage *backBtn = [UIImage imageNamed:@"back"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (IBAction)applyAction:(id)sender
{
    [self.manager saveChanges];
    
    RCMapViewController *mapController = self.mapController;
    
    [mapController reloadProjects];
    
    if (![self.manager isFilteredProjectsContainsProject:[RCMapController selectedProject]]) {
        [mapController closeDetails];
    }
    
    [self sendAnalyticsForFilter];
    
    [self close];
}

- (IBAction)cancelAction:(id)sender
{
    [self.manager discardChanges];
    [self close];
}

- (IBAction)resetFiltersAction:(id)sender
{
    [self.manager resetFilters];
    [self updateUI];
}

- (void)updateUI
{
    self.resetFiltersButton.enabled = [self.manager isFiltersSwitcherOn];
    [self.tableView reloadData];
}

- (void)close
{
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    [nav slideAndPopLayerInDirection:direction_bottom];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self tableModel].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCFilterTableModel *item = [self itemAtIndexPath:indexPath];
    RCFilterBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIDForItem:item] forIndexPath:indexPath];
    [cell updateWithModel:item];
    cell.delegate = self;
    
    if (indexPath.row) {
        cell.userInteractionEnabled = [self.manager isFiltersSwitcherOn];
    }
    
    return cell;
}

- (void)cellValueChanged
{
    [self updateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCFilterTableModel *item = [self itemAtIndexPath:indexPath];
    CGFloat height;
    
    switch (item.cellType) {
        case RCFilterCellTypeFiltersEnabled:
            height = 50.0f;
            break;
            
        case RCFilterCellTypeGroupSelector:
            height = 70.0f;
            break;
            
        case RCFilterCellTypeDateSelector:
            height = 135.0f;
            break;
            
        case RCFilterCellTypeSlider:
            height = 142.0f;
    }
    
    return height;
}

- (RCFilterTableModel *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableModel][(NSUInteger)indexPath.row];
}

- (NSString *)cellReuseIDForItem:(RCFilterTableModel *)item
{
    NSString *reuseID = @"";
    
    switch (item.cellType) {
        case RCFilterCellTypeFiltersEnabled:
            reuseID = @"filtersSwitcher";
            break;
            
        case RCFilterCellTypeGroupSelector:
            reuseID = @"groupSelectionFilter";
            break;
            
        case RCFilterCellTypeDateSelector:
            reuseID = @"filterDates";
            break;
            
        case RCFilterCellTypeSlider:
            reuseID = @"filterSlider";
    }
    
    return reuseID;
}

- (RCFilterManager *)manager
{
    return [RCFilterManager shared];
}

- (NSArray <RCFilterTableModel *> *)tableModel
{
    return self.manager.tableDataModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMultiSelector"]) {
        NSIndexPath *senderIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        RCFilterTableModel *model = [self itemAtIndexPath:senderIndexPath];
        RCFilterMultiSelectController *destinationVC = segue.destinationViewController;
        destinationVC.model = model;
    } else if ([segue.identifier isEqualToString:@"showDateSelector"]) {
        RCFilterDateSelector *destinationVC = segue.destinationViewController;
        destinationVC.popoverPresentationController.delegate = self;
        RCFilterTableModel *model = [self tableModel][3];
        destinationVC.values = model.values;
        destinationVC.completionBlock = ^(NSNumber *selected){
            if ([(UIButton *)sender tag] == 100) {
                if (selected.integerValue < model.currentMax.integerValue) {
                    model.currentMin = selected;
                }
            } else {
                if (selected.integerValue > model.currentMin.integerValue) {
                    model.currentMax = selected;
                }
            }
            [self updateUI];
        };
    }
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void)sendAnalyticsForFilter
{
    if(![self.manager isCurrentConfigDefault]) {
        [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:RCFilterCategory
                                                                       action:RCFilterApplyAction
                                                                        label:[self.manager currentConfiguration].description
                                                                        value:nil];
    }
}

@end
