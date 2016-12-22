
//
//  RCMapViewController.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 14.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController.h"
#import "RCMapDelegate.h"
#import "RCMapToolbarView.h"
#import "RCButtonToolbarItemCell.h"
#import "RCMainTablesScrollView.h"
#import "DragDetector.h"
#import "RCProjectDetailsViewController.h"
#import "MKMapView+More.h"

#import "RCProject.h"
#import "RCImageViewer.h"
#import "RCProject.h"
#import "RCImage.h"
#import "RCNearestTableManager.h"
#import "RCFloatViewSlider.h"
#import "RCProjectDetailsTableManager.h"


@import MapKit;

static NSString * const kMapBoxURLString = @"https://api.mapbox.com/v4/recity.abecc958/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicmVjaXR5IiwiYSI6ImU4MTJmZmE4MGY2ZjI0NzZkMmJjMjNhMzVlMzJiNjM0In0.bNRpbn4mMB4EPHFQ4efrsA";

@interface RCMapViewController () <UIScrollViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet RCMapToolbarView *toolbarView;
@property (weak, nonatomic) IBOutlet RCMainTablesScrollView *scrollView;
@property (strong, nonatomic)  RCProjectDetailsViewController *projectDetailsVC;

@property (weak, nonatomic) IBOutlet UIView *floatView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet RCMapDelegate *mapDelegate;

@property (strong, nonatomic) RCImageViewer *imageViewer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatViewBottomLayout;
@property (weak, nonatomic)IBOutlet NSLayoutConstraint *floatViewHeightConstraint;

@property (strong, nonatomic) NSTimer *updateProjectsTimer;

@property (weak, nonatomic) IBOutlet RCFloatViewSlider *floatViewSlider;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation RCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self prepareScrollView];
    
    self.projectDetailsVC = [RCProjectDetailsViewController new];
    [self.floatView addSubview:self.projectDetailsVC.view];
    self.projectDetailsVC.view.frame = self.floatView.bounds;
    @weakify(self);
    self.projectDetailsVC.didSelectedItemBlock = ^(RCProject *project) {
        @strongify(self);
        [self displayProjectOnMapWithUpdateDetailsVC:project];
        [self.floatViewSlider displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES completion:^{

        }];
    };
    self.floatViewSlider.projectDetailsView = self.projectDetailsVC.view;
    self.floatViewSlider.projectDetailsTableView = self.projectDetailsVC.tableManager.tableView;
    
    [self preparePhotoViewer];
    
    NSArray *projectsFromStore = [RCProject MR_findAll];
    if (projectsFromStore.count > 0) {
        [self.mapDelegate showProjects:projectsFromStore];
    }
    
    static dispatch_queue_t nearestQueue = nil;
    if (nearestQueue == nil) {
        nearestQueue = dispatch_queue_create("nearest", DISPATCH_QUEUE_SERIAL);
    }
    
    [self prepareMapDelegate];
    [self prepareToolbarView];
    
    [self.floatViewSlider prepareAll];
    self.floatViewSlider.menuHalfDisplayedFloatViewHeight = self.mapView.height / 2.0;
    CGFloat detailsHalfDisplayedFloatViewHeight = self.projectDetailsVC.topView.height + self.projectDetailsVC.tableManager.tableView.tableHeaderView.height;
    self.floatViewSlider.detailsHalfDisplayedFloatViewHeight = detailsHalfDisplayedFloatViewHeight;
    
    self.floatViewSlider.didFloatViewBecameHiddenBlock = ^() {
        [self.scrollView.favoriteProjectsVC removeUnfavoritedProjects];
    };
}

- (void)setProjectInDetailsVCWithAddToRecent:(RCProject *)project {
    self.projectDetailsVC.project = project;
    [[AppState sharedInstance].user addRecentProject:project completion:^{
        NSLog(@"recentProjects %@", [[[AppState sharedInstance].user.recentProjects array] valueForKey:@"uid"]);
        [self.scrollView reloadData];
    }];
}

- (void)displayProjectOnMapWithUpdateDetailsVC:(RCProject *)project {
    [self.projectDetailsVC.tableManager.tableView setContentOffset:CGPointZero];
    [self setProjectInDetailsVCWithAddToRecent:project];

    CGPoint offsetForAdd = CGPointMake(0, self.floatViewSlider.detailsHalfDisplayedFloatViewHeight / 2.0);
    CLLocationCoordinate2D visuallyCenteredAtMapViewFreeSpaceCoordinate = [self.mapView visuallyShiftedCoordinate:[[project centerLocation] coordinate] onAddedPixels:offsetForAdd];
    [self.mapView setCenterCoordinate:visuallyCenteredAtMapViewFreeSpaceCoordinate animated:YES];
    
    [self.mapDelegate displayOverlayForProject:project];
}

- (void)prepareScrollView {
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.scrollView updateLayout];
    
    @weakify(self);
    self.scrollView.didFavoritedProjectsListChangedBlock = ^() {
        @strongify(self);
        [self eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow];
    };
    
    self.scrollView.didSelectedProjectBlock = ^(RCProject *project) {
        @strongify(self);
        [self.floatViewSlider hideMenuCompletion:^{
            [self displayProjectOnMapWithUpdateDetailsVC:project];
        } andDisplayProjectDetailsAnimatedCompletion:nil];
    };
}

- (NSTimer *)updateTimer {
    if (!_updateProjectsTimer) {
        _updateProjectsTimer = [NSTimer timerWithTimeInterval:10 * 60 target:self selector:@selector(updateProjects:) userInfo:nil repeats:YES];
        [_updateProjectsTimer fire];
    }
    
    return _updateProjectsTimer;
}

- (void)prepareMapDelegate {
    @weakify(self)
    self.mapDelegate.didMove = ^(RCMapDelegate *delegate, MKMapView *mapView){
        @strongify(self)
        if (![self.floatViewSlider isScrollViewDisplayed]) {
            return;
        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSArray *projects = [RCProject nearestToPoint:mapView.centerCoordinate];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.scrollView.nearestTableManager setItems:projects];
            });
        });
    };
    
    [self updateTimer];
    
    if ([AppState sharedInstance].user.login.length > 0) {
        [[AppState sharedInstance].user downloadUserInfo].then(^(RCUserInfo *info) {
            NSLog(@"DOWNLOADED INFO %@",info);
            [self.mapDelegate updateImagesOfAllDisplayedAnnotations];
        });
    }
    
    self.mapDelegate.didSelectProject = ^(id mapDelegate, RCProject *project) {
        @strongify(self);
        [self setProjectInDetailsVCWithAddToRecent:project];
        
        [self.projectDetailsVC.tableManager.tableView setContentOffset:CGPointZero animated:NO];
        [self.floatViewSlider hideMenuCompletion:nil andDisplayProjectDetailsAnimatedCompletion:nil];
    };
    self.toolbarView.didToolbarItemCellUpdatedBlock = ^(UICollectionView *collectionView, RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath) {
        if (self.toolbarView.state == RCMapToolbarViewStateDetails) {
            if (indexPath.row == 0 && ![self.projectDetailsVC sectionWithTypeIsAvailable:DetailsSectionTypeDevelopmentDetails]) {
                toolbarItemCell.disabled = YES;
            }
            if (indexPath.row == 1) {
            //        if (![self.projectDetailsVC sectionWithTypeIsAvailable:DetailsSectionTypeNotes]) {
                toolbarItemCell.disabled = YES;
            }
            if (indexPath.row == 0 && ![self.projectDetailsVC sectionWithTypeIsAvailable:DetailsSectionTypeNearbyDevelopments]) {
                toolbarItemCell.disabled = YES;
            }
        }
    };
}

- (void)updateProjects:(NSTimer *)timer {
    BOOL willUpdateProjects = !IS_DEBUG_BUILD || (IS_DEBUG_BUILD && [RCProject MR_findAll].count == 0);
    if (willUpdateProjects) {
        [RCProject loadAllProjects].then(^(NSArray *projects) {
            [self.mapDelegate showProjects:projects];
        });
    }
}

- (void)preparePhotoViewer {
    self.imageViewer = [RCImageViewer new];
    self.scrollView.didPressedProjectImageBlock = [self didPressedProjectImageBlock];
    self.projectDetailsVC.didPressedProjectImageBlock = [self didPressedProjectImageBlock];
}

- (void)prepareToolbarView {
    RELAYOUT(self.topView);
    RELAYOUT(self.mapView);
    self.toolbarView.width = self.view.width;
    [self.toolbarView switchStateToNormal];
    
    @weakify(self)
    self.toolbarView.didToolbarViewItemSelectedBlock = ^(NSInteger toolbarViewItemIndex, BOOL selectedItemPressed) {
        @strongify(self);
        if (self.toolbarView.state == RCMapToolbarViewStateNormal) {
            if (toolbarViewItemIndex != 1) {//        favorite
                [self.scrollView.favoriteProjectsVC removeUnfavoritedProjects];
            }
            if (!selectedItemPressed) {
                NSArray *allProjects = [RCProject MR_findAll];
                if (allProjects.count) {
                    if (![self.floatViewSlider isScrollViewDisplayed]) {
                        [self.scrollView reloadData];
                        [self scrollToPage:toolbarViewItemIndex animated:NO];
                        [self.floatViewSlider displayMenuInState:FloatViewStateMenuHalfscreen animated:YES completion:nil];
                    } else {
                        [self scrollToPage:toolbarViewItemIndex animated:YES];
                    }
                } else {
                    [self.toolbarView resetSelectionAnimated:YES];
                    UIAlertController *alertController;
                    alertController = [UIAlertController alertControllerWithTitle:nil message:LOC(@"List of developments is empty. Please try again later") preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:({
                        [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    })];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } else {
                [self.floatViewSlider hideFloatViewAnimatedCompletion:^{
                    [self.toolbarView switchStateToNormal];
                }];
                [self.toolbarView resetSelectionAnimated:YES];
            }
        } else if (self.toolbarView.state == RCMapToolbarViewStateDetails) {
            if ([self.floatViewSlider displayedState] == FloatViewStateDetailsHalfscreen) {
                [self.floatViewSlider displayProjectDetailsInState:FloatViewStateDetailsFullscreen animated:YES completion:^{
                    [self scrollProjectDetailsAccordingWithPressedToolbarViewItemIndex:toolbarViewItemIndex];
                }];
            } else {
                [self scrollProjectDetailsAccordingWithPressedToolbarViewItemIndex:toolbarViewItemIndex];
            }
        }
    };
}

- (void)scrollProjectDetailsAccordingWithPressedToolbarViewItemIndex:(NSInteger)pressedToolbarViewItemIndex {
    switch (pressedToolbarViewItemIndex) {
        case 0: [self.projectDetailsVC scrollToProjectDetailsSection];
            break;
            
        case 1: [self.projectDetailsVC scrollToNotesSection];
            break;
            
        case 2: [self.projectDetailsVC scrollToNearestSection];
            break;
            
        default:
            break;
    }
}

- (DidPressedProjectImageBlock)didPressedProjectImageBlock {
    @weakify(self);
    DidPressedProjectImageBlock block = ^(RCProject *project) {
        @strongify(self);
        NSMutableArray *imagesOrUrls = [@[] mutableCopy];
        for (RCImage *currentImage in project.images) {
            if (currentImage.url) {
                [imagesOrUrls addObject:[NSURL URLWithString:currentImage.url]];
            }
        }
        [self.imageViewer pushInNavigationVC:self.navigationController imagesOrUrls:imagesOrUrls];
    };
    return block;
}



- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(page * self.scrollView.width, self.scrollView.contentOffset.y) animated:animated];
}

#pragma mark - Float View

- (IBAction)close {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {//      erase token
        RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:localContext] firstObject];
        localUser.authorizationToken = @"";
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        NSLog(@"users %@",[RCUser MR_findAll]);
    }];
    [[AppState sharedInstance] eraseKeychainedUserPassword];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate DELEGATE

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.width);
    if (self.toolbarView.state == RCMapToolbarViewStateNormal) {
        [self.toolbarView selectIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    }
    [self eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow];
}

- (void)eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow {
    NSNumber *currentSelectedIndex = [self.toolbarView currentSelectedIndex];
    if (currentSelectedIndex) {
        BOOL willEraseUnfavoritedProjects = self.toolbarView.state == RCMapToolbarViewStateNormal && currentSelectedIndex.integerValue != 1;
        if (willEraseUnfavoritedProjects) {
            [self.scrollView.favoriteProjectsVC removeUnfavoritedProjects];
        }
    }
}

@end
