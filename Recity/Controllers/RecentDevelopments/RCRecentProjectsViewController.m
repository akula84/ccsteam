//
//  RCRecentDevelopmentsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCRecentProjectsViewController.h"

@implementation RCRecentProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)reloadData
{
    NSArray *items = [[[AppState sharedInstance].user.recent reversedOrderedSet] array];
    [self.tableManager setItems:items];
}

@end
