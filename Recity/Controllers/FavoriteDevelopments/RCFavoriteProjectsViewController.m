//
//  RCFavoriteProjectsViewController.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoriteProjectsViewController.h"

#import "RCFavoriteTableManager.h"

@implementation RCFavoriteProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
     RCFavoriteTableManager *tm = (RCFavoriteTableManager *)self.tableManager;
    @weakify(self);
    tm.didFavoritedProjectsListChangedBlock = ^() {
        @strongify(self);
        RUN_BLOCK(self.didFavoritedProjectsListChangedBlock);
    };
    [self registerNotification:YES];
}

- (void)dealloc
{
    [self registerNotification:NO];
}

- (void)registerNotification:(BOOL)enable
{
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"newFavorite" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)reloadData
{
    NSArray *items = [AppState sharedInstance].user.locallyFavoritedItems;
    [self.tableManager setItems:items];
}

- (void)removeUnfavoritedProjects
{
    RCFavoriteTableManager *tm = (RCFavoriteTableManager *)self.tableManager;
    [tm removeUnfavoritedProjects];
}

@end
