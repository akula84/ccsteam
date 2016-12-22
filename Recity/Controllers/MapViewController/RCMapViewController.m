
//
//  RCMapViewController.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 14.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController.h"
#import "RCMapViewController_Private.h"

#import "RCMainTablesScrollView.h"
#import "RCNearestTableManager.h"
#import "RCFloatViewSlider.h"
#import "RCMapDelegate.h"
#import "RCFilterManager.h"
#import "RCProjectAPI.h"
#import "RCCityAPI.h"
#import "RCUserDataAPI.h"
#import "RCAddress.h"
#import "MyLocationButtonController.h"
#import "AppState.h"
#import "RCTutorialManager.h"
#import "RCProject.h"
#import "RCFavoriteProjectsViewController.h"
#import "RCRecentProjectsViewController.h"

@interface RCMapViewController ()

@property (strong, nonatomic) NSTimer *updateProjectsTimer;

@end

@implementation RCMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self prepareLocationManager];
    [self prepareDetailsHistory];
    [self prepareQueue];
    [self updateTimer];
    [self prepareToolbarView];
    [self prepareFloatViewSlider];
    [self prepareDefaultTitle];
    [self initNavItems];
    [self initSearchDelegate];
    [self setupFilterButtonGestures];
    [self setupMapOverlayTaps];
    [self prepareAppVersion];
    [self prepareMapController];
    [self reloadVisibleAddress];
}

- (void)prepareAppVersion
{
    self.filterButton.hidden = ![[self currentUser] hasAdvancedSubscription];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addTapGesture];
    [self prepareScrollView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeTapGesture];
    [self saveCurrentMapSettings];
    
    [super viewWillDisappear:animated];
}

- (void)saveCurrentMapSettings
{
    [AppState saveMapSettings:self.mapDelegate.currentMapSettings];
}

- (void)prepareQueue
{
    static dispatch_queue_t nearestQueue = nil;
    if (nearestQueue == nil) {
        nearestQueue = dispatch_queue_create("nearest", DISPATCH_QUEUE_SERIAL);
    }
}

- (void)reloadProjects
{
    RCFilterManager *manager = [RCFilterManager shared];
    self.filterButton.selected = manager.isFilteringEnabled && ![manager isCurrentConfigDefault];
    NSArray *projectsFromStore = manager.projects;
    [self.mapDelegate showProjects:projectsFromStore];
}

- (NSTimer *)updateTimer
{
    if (!_updateProjectsTimer) {
        _updateProjectsTimer = [NSTimer scheduledTimerWithTimeInterval:10 * 60 target:self selector:@selector(updateProjects:) userInfo:nil repeats:YES];
        [_updateProjectsTimer fire];
    }
    return _updateProjectsTimer;
}

- (void)updateNearbyProjects
{
    dispatch_queue_t queue = dispatch_queue_create("nearby projects update", NULL);
    dispatch_async(queue, ^{
        NSArray *projects = [RCProject nearbyProjectsToPoint:self.mapView.centerCoordinate maxDistanceAsHalfMileChoppedToCount:kMaximumNearbyProjectCountForDisplaying];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.scrollView.nearestTableManager setItems:projects];
        });
    });
}

- (void)updateProjects:(NSTimer *)timer
{
    [self addLoadingViewIsNeed];
    [RCProjectAPI withCompletion:^(id reply, NSError *error, BOOL *handleError) {
        [self updateProjectsCompleted];
    }];
}

- (void)updateProjectsCompleted
{
    [self appState].firstProjectsDownloadingFinished = YES;
    [self removeLoadingView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProjectsLoaded object:nil];
    [self reloadProjects];
    if ([self currentUser].login.length > 0) {
        [RCUserDataAPI withCompletion:^(id repl, NSError *erro, BOOL *handlError) {
            [self.mapDelegate updateImagesOfVisibleAnnotations];
            [self reloadVisibleAddress];
            [self loadCities];
            [RCTutorialManager beginTutorialIfNeeded];
            [self.scrollView.favoriteProjectsVC reloadData];
        }];
    }
}

- (void)loadCities
{
    [RCCityAPI withCompletion:nil];
}

- (void)closeDetails
{
    [self deSelectCurrentItem];
    [self.floatViewSlider hideFloatViewAnimatedCompletion:^{}];
}

- (AppState *)appState
{
    return [AppState sharedInstance];
}

- (RCUser *)currentUser
{
    return [self appState].user;
}

- (NSMutableArray<UIViewController *> *)detailsHistory
{
    if (!_detailsHistory) {
        _detailsHistory = [NSMutableArray array];
    }
    return _detailsHistory;
}

- (void)addRecentItem:(id)item
{
    [[self currentUser] addRecentItem:item completion:^{
        [self.scrollView.recentProjectsVC reloadData];
    }];
}

- (void)showItem:(id)item
{
    if ([item isKindOfClass:[RCProject class]]) {
        [self displayProjectOnMapWithUpdateDetailsVC:item];
    } else if ([item isKindOfClass:[RCAddress class]]) {
        [self showAddress:item];
    }
}

- (void)deSelectCurrentItem
{
    [self.mapDelegate deSelectCurrentItem];
}

@end
