//
//  RCNearestProjectsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNearestProjectsViewController.h"

#import "RCNearestTableManager.h"
#import "RCMapController.h"

@implementation RCNearestProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
    
    RCNearestTableManager *nearestTM = (RCNearestTableManager *)self.tableManager;
    nearestTM.didPressedProjectImageBlock = [RCMapController didPressedProjectImageBlock];
}

- (void)reloadData
{
    //      reload will be called from outside
}

@end
