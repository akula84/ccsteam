//
//  MainTablesScrollView.m
//  Recity
//
//  Created by Matveev on 15/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMainTablesScrollView.h"

#import "RCFloatViewSliderController.h"
#import "RCMapController.h"
#import "RCToolbarController.h"
#import "RCFavoriteProjectsViewController.h"
#import "RCNearestProjectsViewController.h"
#import "RCRecentProjectsViewController.h"

@interface RCMainTablesScrollView () <UIScrollViewDelegate>

@end

@implementation RCMainTablesScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    
    _recentProjectsVC = [RCRecentProjectsViewController new];
    _favoriteProjectsVC = [RCFavoriteProjectsViewController new];
    _nearestProjectsVC = [RCNearestProjectsViewController new];
    
    @weakify(self);
    self.recentProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        [self didSelectedItemBlock:project];
    };
    self.favoriteProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        [self didSelectedItemBlock:project];
     };
    self.nearestProjectsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        [self didSelectedItemBlock:project];
    };
    
    _favoriteProjectsVC.didFavoritedProjectsListChangedBlock = ^() {
        @strongify(self);
        [self didFavoritedProjectsListChangedBlock];
    };
    [self updateLayout];
}


- (void)didFavoritedProjectsListChangedBlock
{
    [RCToolbarController eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow:^{
        [self.favoriteProjectsVC removeUnfavoritedProjects];
    }];
}

- (void)didSelectedItemBlock:(RCProject *)project
{
    [RCFloatViewSliderController hideMenuCompletion:^{
        [RCMapController showItem:project];
    } andDisplayProjectDetailsAnimatedCompletion:nil];
}

- (void)updateLayout
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    NSArray *views = @[self.recentProjectsVC.view, self.favoriteProjectsVC.view, self.nearestProjectsVC.view];
    [self setContentSize:CGSizeMake(views.count * self.width, self.height)];
    for (NSUInteger i = 0; i < views.count; ++i) {
        UIView *currentView = views[i];
        [self addSubview:currentView];
        currentView.frame = self.bounds;
        currentView.x = i * self.width;
    }
    self.bounces = NO;
}

- (RCNearestTableManager *)nearestTableManager
{
    return (id)self.nearestProjectsVC.tableManager;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.width);
    
    [RCToolbarController selectIndexPathIfNormal:[NSIndexPath indexPathForRow:page inSection:0]];
    
    [self sendScreenForAnalystWithPage:page];
}

- (void)sendScreenForAnalystWithPage:(NSInteger)page
{
    NSString *screenName = [self screenNameForPage:page];
    [[RCAnalyticsServicesComposite sharedInstance] trackScreenWithName:screenName];
}

- (NSString *)screenNameForPage:(NSInteger)page
{
    NSString *screenName = nil;
    switch (page) {
        case 0:
            screenName = [RCRecentProjectsViewController rc_className];
            break;
        case 1:
            screenName = [RCFavoriteProjectsViewController rc_className];
            break;
        case 2:
            screenName = [RCNearestProjectsViewController rc_className];
            break;
        default:
            break;
    }
    return screenName;
}

@end
