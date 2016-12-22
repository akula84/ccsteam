//
//  RCDINearbyTypesViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDINearbyTypesViewController.h"

#import "RCDINearbyTypesProjectCell.h"
#import "RCSegmentedProcentageSelector.h"
#import "WhatIsThisPopupView.h"
#import "RCMapController.h"

static const CGFloat projectRowHeight = 120.0f;
static const CGFloat tableHeaderHeight = 75.0f;

@interface RCDINearbyTypesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *projectsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation RCDINearbyTypesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentedSelector.selectionColor = RGB(244, 142, 41);
}

- (void)setProjects:(NSArray <RCProject *> *)projects
{
    _projects = projects;
    [self updateUI];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.projects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return projectRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diProjectCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(RCDINearbyTypesProjectCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell updateWithProject:[self itemAtIndexPath:indexPath] andAddress:self.address];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RCProject *project = [self itemAtIndexPath:indexPath];
    [RCMapController showItem:project];
}

- (RCProject *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.projects[(NSUInteger)indexPath.row];
}

- (IBAction)infoButtonAction:(id)sender
{
    WhatIsThisPopupView *info = [WhatIsThisPopupView loadNib];
    
    UIView *mainView = self.view.superview;
    while (mainView.superview) {
        mainView = mainView.superview;
    }

    [info displayOnView:mainView];
}

- (void)updateTableHeight
{
    self.tableViewHeightConstraint.constant = [self viewHeight];
}

- (void)updateUI
{
    if (self.projects.count == 1) {
        self.projectsCountLabel.text = [NSString stringWithFormat:@"1 PROJECT"];
    } else {
        self.projectsCountLabel.text = [NSString stringWithFormat:@"%lu PROJECTS", (unsigned long)self.projects.count];
    }
    self.groupTitleLabel.text = self.groupTitle;
    self.infoButton.hidden = ![self.groupTitle isEqualToString:@"Other"];
}

- (CGFloat)viewHeight
{
    return self.projects.count * projectRowHeight + tableHeaderHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateTableHeight];
    [self updateUI];
}

@end
