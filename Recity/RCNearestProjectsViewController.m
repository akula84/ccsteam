//
//  RCNearestProjectsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNearestProjectsViewController.h"
#import "RCProject.h"
#import "RCNearestTableManager.h"

@interface RCNearestProjectsViewController ()

@end

@implementation RCNearestProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
    
    RCNearestTableManager *nearestTM = (RCNearestTableManager *)self.tableManager;
    @weakify(self);
    nearestTM.didPressedProjectImageBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock,project);
    };
}

- (void)reloadData {
    NSArray *items = [RCProject MR_findAll];
    [self.tableManager setItems:items];
}

@end
