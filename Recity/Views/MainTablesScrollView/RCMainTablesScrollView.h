//
//  MainTablesScrollView.h
//  Recity
//
//  Created by Matveev on 15/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCRecentProjectsViewController,RCFavoriteProjectsViewController,RCNearestProjectsViewController,RCNearestTableManager;

@class RCNearestTableManager;

@interface RCMainTablesScrollView : UIScrollView

@property (readonly, strong, nonatomic) RCRecentProjectsViewController *recentProjectsVC;
@property (readonly, strong, nonatomic) RCFavoriteProjectsViewController *favoriteProjectsVC;
@property (readonly, strong, nonatomic) RCNearestProjectsViewController *nearestProjectsVC;
@property (readonly) RCNearestTableManager *nearestTableManager;

- (void)updateLayout;

- (void)sendScreenForAnalystWithPage:(NSInteger)page;

@end
