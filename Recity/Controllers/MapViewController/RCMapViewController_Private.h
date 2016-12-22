//
//  RCMapViewController+NavigationItems.h
//  Recity
//
//  Created by Artem Kulagin on 30.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController.h"

#import "RCSearchManagerDelegate.h"
#import "VKSideMenu.h"
#import "DFContinuousForceTouchGestureRecognizer.h"

@import MapKit;

static CGFloat offsetXCursor = 87.f;
static NSString *defaultBarTitle = @"Search DC";

@class RCSearchRecentView, RCSearchResultView, MKMapView, RCMapDelegate, RCFloatViewSlider, RCProjectDetailsViewController,
RCMapToolbarView, CLLocationManager, RCMainTablesScrollView, RCAddress, RCSignView, RCAddressPageController,LoaderView;

@interface RCMapViewController()

@property (strong, nonatomic) IBOutlet RCSearchRecentView *recentView;
@property (strong, nonatomic) IBOutlet RCSearchResultView *resultView;
@property (strong, nonatomic) IBOutlet RCMapDelegate *mapDelegate;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet RCFloatViewSlider *floatViewSlider;
@property (weak, nonatomic) IBOutlet RCMapToolbarView *toolbarView;
@property (weak, nonatomic) IBOutlet UIView *floatView;
@property (weak, nonatomic) IBOutlet RCMainTablesScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myLocationButtonConstrains;
@property (strong, nonatomic) UIBarButtonItem *menuItem;
@property (strong, nonatomic) UIBarButtonItem *searchItem;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UITapGestureRecognizer *tapNav;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableArray <UIViewController *> *detailsHistory;
@property (strong, nonatomic) NSTimer *timerLocation;
@property (strong, nonatomic) LoaderView *loaderView;

- (void)updateNearbyProjects;
- (AppState *)appState;
- (void)addRecentItem:(id)item;
- (void)showItem:(id)item;
- (void)deSelectCurrentItem;

- (void)saveCurrentMapSettings;

@end

@interface RCMapViewController (FilterActions) <DFContinuousForceTouchDelegate>

- (void)setupFilterButtonGestures;

@end

@interface RCMapViewController (NavigationItems)

- (void)initNavItems;
- (void)visibleSearchNavItems;
- (void)visibleDefaultsNavItems;

@end

@interface RCMapViewController (SearchNav)

- (CGRect)boundsNavigationBar;
- (UINavigationBar *)navigationBar;
- (void)moveLeftTitleBar;

@end

@interface RCMapViewController (TextField)<UITextFieldDelegate>

- (void)addSearchTextField;
- (void)removeSearchTextField;
- (void)searchTextFieldCheckHaveText;
- (void)searchTextFieldText:(NSString *)text;
- (BOOL)isSearchTextFieldClear;
- (void)searchTextFieldClear;
- (void)searchTextFieldReturn;
- (void)searchTextFieldSearch;
- (void)searchTextFieldResignFirstResponder;

@end

@interface RCMapViewController (Search)

- (void)closeSearch;
- (void)checkPossibleSearch;
- (void)recentViewShow;
- (void)recentViewRemove;
- (void)resultViewShow;

@end

@interface RCMapViewController (SearchDelegate) <RCSearchManagerDelegate>

- (void)initSearchDelegate;

@end

@interface RCMapViewController (NavTitle)

- (void)prepareClearTitle;
- (void)prepareDefaultTitle;
- (void)prepareTitleFromItem:(id)item;

@end

@interface RCMapViewController (DetailHistory) <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (void)prepareDetailsHistory;
- (void)showObjectInHistory:(id)object;
- (UIViewController *)currentDetailsController;
- (void)myLocationButtonUp:(BOOL)value;

@end

@interface RCMapViewController (ProjectDetails)

- (RCProjectDetailsViewController *)detailsViewControllerForProject:(RCProject *)project;
- (void)addProjectToHistory:(RCProject *)project;
- (NSUInteger)indexInHistoryOfProject:(RCProject *)project;

@end

@interface RCMapViewController (DevelopmentIndex)

- (RCAddressPageController *)developmentIndexViewControllerForAddress:(RCAddress *)address;
- (void)addAddressToHistory:(RCAddress *)address;
- (NSUInteger)indexInHistoryOfAddress:(RCAddress *)address;

@end

@interface RCMapViewController (MapView)

- (void)displayProjectOnMapAndAddToRecent:(RCProject *)project;
- (void)displayProjectOnMapWithUpdateDetailsVC:(RCProject *)project;
- (void)displayAddressOnMap:(RCAddress *)address;
- (void)displayProjectOnMap:(RCProject *)project;
- (void)showAddress:(RCAddress *)address;

@end

@interface RCMapViewController (LocationManager) <CLLocationManagerDelegate>

- (void)prepareLocationManager;
- (void)didShowMyself;

@end

@interface RCMapViewController (Gesture)

- (void)addTapGesture;
- (void)removeTapGesture;
- (void)setupMapOverlayTaps;

@end


@interface RCMapViewController (Controller)

- (void)prepareMapController;
- (void)reloadVisibleAddress;
- (void)showAlert;

@end

@interface RCMapViewController (SubViews)

- (void)prepareScrollView;
- (void)prepareToolbarView;
- (void)prepareFloatViewSlider;
- (void)addLoadingViewIsNeed;
- (void)removeLoadingView;

@end
