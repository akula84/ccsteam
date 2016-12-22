//
//  RCMapViewController+SubViews.m
//  Recity
//
//  Created by Artem Kulagin on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCMainTablesScrollView.h"
#import "RCMapToolbarView.h"
#import "RCToolbarController.h"
#import "RCFloatViewSlider.h"
#import "MyLocationButtonController.h"
#import "RCFavoriteProjectsViewController.h"
#import "LoaderView.h"
#import "ApiUtils.h"
#import "RCSizeHelper.h"

@implementation RCMapViewController (SubViews)

- (void)prepareScrollView
{
    [self.scrollView updateLayout];
}

- (void)prepareToolbarView
{
    RELAYOUT(self.mapView);
    self.toolbarView.width = self.view.width;
    [RCToolbarController switchToolbarToState:RCMapToolbarViewStateNormal];
}

- (void)prepareFloatViewSlider
{
    RCFloatViewSlider *floatViewSlider = self.floatViewSlider;
    [floatViewSlider prepareAll];
    floatViewSlider.menuHalfDisplayedFloatViewHeight = self.mapView.height / 2.0f;
    floatViewSlider.detailsHalfDisplayedFloatViewHeight = [RCSizeHelper detailsHalfHeight];
    floatViewSlider.didFloatViewBecameHiddenBlock = ^() {
        [self didFloatViewBecameHiddenBlock];
    };
    floatViewSlider.didFloatViewBecameHalfBlock = ^{
        [self myLocationButtonUp:YES];
    };
}

- (void)didFloatViewBecameHiddenBlock
{
    [self.scrollView.favoriteProjectsVC removeUnfavoritedProjects];
    [self deSelectCurrentItem];
    [self myLocationButtonUp:NO];
    [MyLocationButtonController prepareActived:NO];
}

- (void)addLoadingViewIsNeed
{
    if ([ApiUtils isHaveProjectsInBase]) {return;}
    
    LoaderView *loaderView = [[LoaderView alloc]initWithFrame:self.view.bounds];
    [loaderView prepareLogin];
    [loaderView showLoadingProject];
    loaderView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        loaderView.alpha = 1.0f;
    } completion:nil];
    [self.navigationController.view addSubview: loaderView];
    self.loaderView = loaderView;
}

- (void)removeLoadingView
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        LoaderView *loaderView = self.loaderView;
        loaderView.alpha = 0.0f;
        [loaderView removeFromSuperview];
    } completion:nil];
    
}

@end
