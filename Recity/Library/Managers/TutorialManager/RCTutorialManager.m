//
//  RCTutorialManager.m
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTutorialManager.h"

#import "RCTutorialPageModel.h"

#import "RCFloatViewSlider.h"
#import "RCProjectDetailsViewController.h"
#import "RCAddressPageController.h"
#import "RCProject.h"
#import "RCMapController.h"
#import "RCAddress.h"

@interface RCTutorialManager()

@property (strong, nonatomic) NSArray <RCTutorialPageModel *> *pages;

@property (nonatomic) MKMapRect savedMapRect;
@property (strong, nonatomic) RCProject *savedProject;
@property (strong, nonatomic) RCAddress *savedAddress;

@property (strong, nonatomic) RCProject *projectToShow;

@end

@implementation RCTutorialManager

SINGLETON_OBJECT

- (NSUInteger)pagesCount
{
    return self.pages.count;
}

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex < self.pages.count ? currentPageIndex : self.pages.count - 1;
}

- (RCTutorialPageModel *)currentPage
{
    return [self pageAtIndex:self.currentPageIndex];
}

- (RCTutorialPageModel *)previousPage
{
    return [self pageAtIndex:self.currentPageIndex - 1];
}

- (RCTutorialPageModel *)nextPage
{
    return [self pageAtIndex:self.currentPageIndex + 1];
}

- (RCTutorialPageModel *)pageAtIndex:(NSUInteger)index
{
    RCTutorialPageModel *result = nil;
    if (index < self.pages.count) {
        result = self.pages[index];
    }
    return result;
}

- (void)setCurrentModel:(RCTutorialPageModel *)model
{
    if ([self.pages containsObject:model]) {
        self.currentPageIndex = [self.pages indexOfObject:model];
    }
}

- (void)saveState
{
    RCMapViewController *mapViewController = self.mapView;
    
    self.savedMapRect = mapViewController.mapView.visibleMapRect;
    
    if ([mapViewController.floatViewSlider displayedState] == FloatViewStateDetailsFullscreen ||
        [mapViewController.floatViewSlider displayedState] == FloatViewStateDetailsHalfscreen) {
        UIViewController *controller = [mapViewController currentDetailsController];
        if ([controller isKindOfClass:[RCProjectDetailsViewController class]]) {
            self.savedProject = [(RCProjectDetailsViewController *)controller project];
        } else if ([controller isKindOfClass:[RCAddressPageController class]]) {
            self.savedAddress = [(RCAddressPageController *)controller address];
        }
    }
}

- (RCMapViewController *)mapView
{
    return [RCMapController shared].mapView;
}

- (void)resetState
{
    RCMapViewController *mapViewController = self.mapView;

    [mapViewController.mapView setVisibleMapRect:self.savedMapRect animated:YES];
    [mapViewController.floatViewSlider hideFloatViewAnimatedCompletion:nil];
    
    if (self.savedProject) {
        [mapViewController showItem:self.savedProject];
    } else if (self.savedAddress) {
        [mapViewController showItem:self.savedAddress];
    }
    
    self.savedAddress = nil;
    self.savedProject = nil;
}

- (NSArray <RCTutorialPageModel *> *)pages
{
    return [self createPages];
}

- (NSArray *)createPages
{
    RCMapViewController *mapViewController = self.mapView;
    
    UIView *mapView = mapViewController.view;
    UIView *mainView = mapViewController.navigationController.view;
    BOOL advanced = [AppState advancedVersion];
    
    //---------Page 1---------
    RCTutorialPageModel *page1 = [RCTutorialPageModel new];
    page1.title = @"Search, Favorites, and More";
    page1.text = @"Use the search bar at the top to search for both developments and addresses.\n\nUse the navigation buttons at the bottom to access Recent Searches, Favorites, and Nearby Developments.";
    
    CGRect filterFrame = CGRectInset(mapViewController.filterButton.frame, -10.0f, -10.0f);
    filterFrame = [mapView convertRect:filterFrame toView:mainView];
    NSValue *filterFrameValue = [NSValue valueWithCGRect:filterFrame];
    
    CGRect topBarFrame = mapViewController.navigationController.navigationBar.frame;
    topBarFrame.size.height += 6.0f;
    NSValue *topBarFrameValue = [NSValue valueWithCGRect:topBarFrame];
    
    CGRect bottomBarFrame = [(UIView *)mapViewController.toolbarView frame];
    bottomBarFrame = [mapView convertRect:bottomBarFrame toView:mainView];
    NSValue *bottomBarFrameValue = [NSValue valueWithCGRect:bottomBarFrame];
    
    page1.viewHoleFrames = @[topBarFrameValue, bottomBarFrameValue];
    if (advanced) {
        page1.viewHoleFrames = [page1.viewHoleFrames arrayByAddingObject:filterFrameValue];
    }
    page1.selectionAction = ^{
        [mapViewController.floatViewSlider hideFloatViewAnimatedCompletion:nil];
    };
    
    //---------Page 2---------
    RCTutorialPageModel *page2 = [RCTutorialPageModel new];
    page2.title = @"Development Status";
    page2.text = @"Each pin on the map is a development. You can quickly tell what a development’s status is from the color.";
    page2.needShowImage = YES;
    
    CGRect projectsFrame = CGRectMake(0, 76.0f, CGRectGetWidth(mainView.frame), CGRectGetHeight(mainView.frame) - 431.0f);
    NSValue *projectsFrameValue = [NSValue valueWithCGRect:projectsFrame];
    
    page2.viewHoleFrames = @[projectsFrameValue];
    
    page2.selectionAction = ^{
        self.projectToShow = [RCTutorialManager projectForCurrentCity];
        
        [mapViewController displayProjectOnMap:self.projectToShow];
        [mapViewController.floatViewSlider hideFloatViewAnimatedCompletion:nil];
    };
    
    //---------Page 3---------
    RCTutorialPageModel *page3 = [RCTutorialPageModel new];
    page3.title = @"Development Preview & Details";
    page3.text = @"Tap on a pin to see a preview card of the development.\n\nTo see more details, scroll down or tap on an icon on the bottom bar.";
    page3.moveUp = YES;
    
    CGRect detailsFrame = CGRectMake(0, CGRectGetMaxY(mainView.frame) - 236.0f, CGRectGetWidth(mainView.frame), 236.0f);
    NSValue *detailsFrameValue = [NSValue valueWithCGRect:detailsFrame];
    
    page3.viewHoleFrames = @[detailsFrameValue];
    
    page3.selectionAction = ^{
        [mapViewController showObjectInHistory:self.projectToShow];
        [mapViewController.detailsHistory removeObject:[mapViewController currentDetailsController]];
    };
    
    //---------Page 4---------
    RCTutorialPageModel *page4 = [RCTutorialPageModel new];
    page4.title = @"Development Index & Outlook";
    page4.text = @"Every address has a Development Index (0-100) indicating the expected future construction activity in a nearby walkable area.\nThe Growth Outlook indicates timing of these projects, as they occur over the next 10+ years.";
    page4.moveUp = YES;
    
    page4.viewHoleFrames = @[detailsFrameValue];
    
    page4.selectionAction = ^{
        [mapViewController displayAddressOnMap:[self.projectToShow addressObject]];
        [mapViewController showObjectInHistory:[self.projectToShow addressObject]];
        [mapViewController.detailsHistory removeObject:[mapViewController currentDetailsController]];
    };
    
    //---------Page 5---------
    RCTutorialPageModel *page5 = [RCTutorialPageModel new];
    page5.title = @"Advanced Metrics";
    page5.text = @"Dig deeper into the data with advanced metrics.\n\nGet the high-level summary or tap to expand each section and get more detail. ";
    
    page5.viewHoleFrames = @[projectsFrameValue];
    
    page5.selectionAction = ^{
        [mapViewController.floatViewSlider displayProjectDetailsInState:FloatViewStateDetailsFullscreen animated:YES timeInterval:@0.2 completion:nil];
        RCAddressPageController *controller = (RCAddressPageController *)[mapViewController currentDetailsController];
        [controller scrollToMetrics];
    };
    
    NSArray *pages = @[page1, page2, page3, page4];
    if (advanced) {
        pages = [pages arrayByAddingObject:page5];
    }
    
    return pages;
}

+ (RCProject *)projectForCurrentCity
{
    NSDictionary *projectsForCities = @{@1 : @382};
    
    NSNumber *cityId = [AppState sharedInstance].user.homeCityId;
    RCProject *result = [RCProject MR_findFirstByAttribute:@"uid" withValue:projectsForCities[cityId]inContext:[NSManagedObjectContext MR_defaultContext]];
    RCAddress *addressObject = [result addressObject];
    addressObject.saveDevelopmentIndex = YES;
    [addressObject downloadDevelopmentIndex:nil];

    return result;
}

@end
