//
//  RCFavoriteProjectsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoriteProjectsViewController.h"
#import "RCFavoriteTableManager.h"
#import "RCProject.h"
#import "RCUser.h"

@interface RCFavoriteProjectsViewController ()

@end

@implementation RCFavoriteProjectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadData];
    
    RCFavoriteTableManager *tm = (RCFavoriteTableManager *)self.tableManager;
    @weakify(self);
    tm.didFavoritedProjectsListChangedBlock = ^() {
        @strongify(self);
        RUN_BLOCK(self.didFavoritedProjectsListChangedBlock);
    };
}

- (void)reloadData {
    NSArray *items = [AppState sharedInstance].user.locallyFavoritedProjects;
    [self.tableManager setItems:items];
}

- (void)removeUnfavoritedProjects {
    RCFavoriteTableManager *tm = (RCFavoriteTableManager *)self.tableManager;
    [tm removeUnfavoritedProjects];
}

@end
