//
//  RCRecentDevelopmentsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCRecentProjectsViewController.h"
#import "RCUser.h"
#import "RCProject.h"

@interface RCRecentProjectsViewController ()

@end

@implementation RCRecentProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)reloadData {
    NSArray *items = [[[AppState sharedInstance].user.recentProjects reversedOrderedSet] array];
    [self.tableManager setItems:items];
}

@end
