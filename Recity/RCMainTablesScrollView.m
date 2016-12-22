//
//  MainTablesScrollView.m
//  Recity
//
//  Created by Matveev on 15/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMainTablesScrollView.h"

@interface RCMainTablesScrollView () <UIScrollViewDelegate>

@end

@implementation RCMainTablesScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pagingEnabled = YES;
    
    _recentProjectsVC = [RCRecentProjectsViewController new];
    _favoriteProjectsVC = [RCFavoriteProjectsViewController new];
    _nearestProjectsVC = [RCNearestProjectsViewController new];
    
    @weakify(self);
    self.recentProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didSelectedProjectBlock,project);
    };
    self.favoriteProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didSelectedProjectBlock,project);
    };
    self.nearestProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didSelectedProjectBlock,project);
    };
    
    _favoriteProjectsVC.didFavoritedProjectsListChangedBlock = ^() {
        @strongify(self);
        RUN_BLOCK(self.didFavoritedProjectsListChangedBlock);
    };
    
    self.nearestProjectsVC.didPressedProjectImageBlock = ^(RCProject *project) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock, project);
    };
    
    [self updateLayout];
}

- (void)updateLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    NSArray *views = @[self.recentProjectsVC.view, self.favoriteProjectsVC.view, self.nearestProjectsVC.view];
    [self setContentSize:CGSizeMake(views.count * self.width, self.height)];
    for (NSInteger i = 0; i < views.count; ++i) {
        UIView *currentView = views[i];
        [self addSubview:currentView];
        currentView.frame = self.bounds;
        currentView.x = i * self.width;
    }
    self.bounces = NO;
}

- (RCNearestTableManager *)nearestTableManager {
    return (id)self.nearestProjectsVC.tableManager;
}

- (void)reloadData {
    NSArray *vcs = @[self.recentProjectsVC, self.favoriteProjectsVC, self.nearestProjectsVC];
    for (RCBaseTableViewController *tableVC in vcs) {
        [tableVC reloadData];
    }
}

@end
