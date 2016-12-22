//
//  RCFloatViewSlider+Controller.m
//  Recity
//
//  Created by Artem Kulagin on 07.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSlider_Private.h"

#import "RCFloatViewSliderController.h"
#import "RCMainTablesScrollView.h"
#import "RCMapController.h"
#import "RCFavoriteProjectsViewController.h"
#import "RCNearestProjectsViewController.h"
#import "RCRecentProjectsViewController.h"
#import "RCTableManager.h"

@implementation RCFloatViewSlider (Controller)

- (void)prepareController
{
    @weakify(self);
    
    RCFloatViewSliderController *controller = [RCFloatViewSliderController shared];
    controller.didNoDetectTableView = ^(UITableView *tableView){
        @strongify(self);
        [self setProjectDetailsTableView:tableView];
    };
    controller.didDisplayFullscreen = ^(){
        @strongify(self);
        if (!self.isPanRecognizedOnLastRecognizedTouch) {
            [self displayProjectDetailsInState:FloatViewStateDetailsFullscreen animated:YES timeInterval:nil completion:^{
            }];
        }
    };
    
    controller.didDisplayFullscreenIfHalf = ^(dispatch_block_t complete){
        @strongify(self);
        if ([self displayedState] == FloatViewStateDetailsHalfscreen) {
            [self displayProjectDetailsInState:FloatViewStateDetailsFullscreen animated:YES timeInterval:@(0.3) completion:complete];
        } else {
            RUN_BLOCK(complete);
        }
    };
    
    controller.didDisplayHalfscreen = ^(){
        @strongify(self);
        [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES timeInterval:nil completion:nil];
    };
    
    controller.didDisplayHalfscreenIfFull = ^(dispatch_block_t complete){
        @strongify(self);
        if ([self displayedState] == FloatViewStateDetailsFullscreen) {
            [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES timeInterval:@(0.3) completion:complete];
        } else {
            RUN_BLOCK(complete)
        }
    };
    
    controller.didPrepareToolbarFromStateNormal = ^(NSInteger toolbarViewItemIndex,BOOL selectedItemPressed){
        @strongify(self);
        [self prepareToolbarFromStateNormal:toolbarViewItemIndex selectedItemPressed:selectedItemPressed];
    };
    
    controller.didHideMenuCompletion = ^(dispatch_block_t completion1, dispatch_block_t completion2){
        @strongify(self);
        [self hideMenuCompletion:completion1 andDisplayProjectDetailsAnimatedCompletion:completion2];
    };
    
    controller.didUpdateNearbyProjectsIfNeed = ^{
        if ([self isScrollViewDisplayed]) {
            [RCMapController updateNearbyProjects];
        }
    };
    
    controller.isDisplayedFull = ^{
        @strongify(self);
        BOOL result = (self.displayedState == FloatViewStateDetailsFullscreen);
        return result;
    };
    
    controller.isScrollViewMoved = ^{
        @strongify(self);
        return self.isScrollViewMoved;
    };
}

- (void)prepareToolbarFromStateNormal:(NSInteger)toolbarViewItemIndex selectedItemPressed:(BOOL)selectedItemPressed
{
    //[self resetSelectionAnimated:YES];
    switch (toolbarViewItemIndex) {
        case 0:
            [self.scrollView.recentProjectsVC.tableManager.tableView setContentOffset:CGPointZero];
            break;
            
        case 1:
            [self.scrollView.favoriteProjectsVC.tableManager.tableView setContentOffset:CGPointZero];
            break;
            
        case 2:
            [self.scrollView.nearestProjectsVC.tableManager.tableView setContentOffset:CGPointZero];
            break;
            
        default:
            break;
    }
    if (toolbarViewItemIndex != 1) {//        favorite
        [self.scrollView.favoriteProjectsVC removeUnfavoritedProjects];
    }
    if (![self isScrollViewDisplayed]) {
        [RCMapController updateNearbyProjects];
    }
    if (!selectedItemPressed) {
        if ([AppState sharedInstance].firstProjectsDownloadingFinished) {
            if (![self isScrollViewDisplayed]) {
                [self scrollToPage:toolbarViewItemIndex animated:NO];
                [self displayMenuInState:FloatViewStateMenuHalfscreen animated:YES completion:nil];
            } else {
                [self scrollToPage:toolbarViewItemIndex animated:YES];
            }
        } else {
            [self resetSelectionAnimated:YES];
            [RCMapController showAlert];
        }
    } else {
        [self hideFloatViewAnimatedCompletion:^{
            [RCToolbarController switchToolbarToState:RCMapToolbarViewStateNormal];
        }];
        [self resetSelectionAnimated:YES];
    }
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake(page * self.scrollView.width, self.scrollView.contentOffset.y) animated:animated];
    [self.scrollView sendScreenForAnalystWithPage:page];
}

- (void)resetSelectionAnimated:(BOOL)animated
{
    [RCToolbarController resetSelectionAnimated:animated];
}

@end
