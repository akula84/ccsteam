//
//  RCMapViewController+AnimationSearchRecent.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCSearchRecentView.h"
#import "MKMapView+More.h"
#import "CGRect+Utils.h"
#import "RCSearchResultView.h"
#import "RCProject.h"
#import "RCSearchManager.h"
#import "RCMapController.h"

@implementation RCMapViewController (Search)

- (void)checkPossibleSearch
{
    if ([self appState].firstProjectsDownloadingFinished) {
        [self startSearch];
    } else {
        [self showAlert];
    }
}

- (void)startSearch
{
    self.searchManager.searchInProgress = YES;
    [self showResultAddressInMapisNeed];
    [self visibleSearchNavItems];
    [self moveLeftTitleBar];
    [self searchTextFieldCheckHaveText];
    
    [[RCAnalyticsServicesComposite sharedInstance] trackScreenWithName:@"Search"];
}

- (void)showResultAddressInMapisNeed
{
    self.searchManager.showResultAddressInMap = YES;
    [RCMapController reloadVisibleAddress];
}

- (void)closeSearch
{
    RCSearchManager *searchManager = self.searchManager;
    searchManager.searchInProgress = NO;
    [self searchTextFieldResignFirstResponder];
    [self removeSearchTextField];
    [self closeAllView];
    [self visibleDefaultsNavItems];
    [self prepareDefaultTitle];
    searchManager.searchText = nil;
    
    
    [[RCAnalyticsServicesComposite sharedInstance] trackScreenWithName:[self rc_className]];
}

- (RCSearchManager *)searchManager
{
    return [RCSearchManager shared];
}

- (void)closeAllView
{
    [self recentViewRemove];
    [self resultViewRemove];
}

- (void)recentViewShow
{
    [self resultViewRemove];
    [self.recentView show];
}

- (void)recentViewRemove
{
    [self.recentView remove];
}

- (void)resultViewShow
{
    [self recentViewRemove];
    [self.resultView show];
}

- (void)resultViewRemove
{
    [self.resultView remove];
}

@end
