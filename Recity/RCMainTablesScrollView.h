//
//  MainTablesScrollView.h
//  Recity
//
//  Created by Matveev on 15/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCFavoriteProjectsViewController.h"
#import "RCNearestProjectsViewController.h"
#import "RCRecentProjectsViewController.h"
#import "RCTableManager.h"

@class RCNearestTableManager;

@interface RCMainTablesScrollView : UIScrollView

@property (readonly, strong, nonatomic) RCRecentProjectsViewController *recentProjectsVC;
@property (readonly, strong, nonatomic) RCFavoriteProjectsViewController *favoriteProjectsVC;
@property (readonly, strong, nonatomic) RCNearestProjectsViewController *nearestProjectsVC;

@property (strong, nonatomic) dispatch_block_t didFavoritedProjectsListChangedBlock;

@property (strong, nonatomic) DidPressedProjectImageBlock didPressedProjectImageBlock;
@property (copy, nonatomic) RCTableItemBlock didSelectedProjectBlock;

@property (readonly) RCNearestTableManager *nearestTableManager;

- (void)updateLayout;
- (void)reloadData;

@end
