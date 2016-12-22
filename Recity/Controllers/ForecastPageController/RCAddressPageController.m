//
//  RCForecastPageController.m
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddressPageController.h"
#import "RCAddressPageController_Private.h"

#import "RCDevelopmentIndexViewController.h"
#import "RCForecastViewController.h"
#import "RCDevelopmentIndexNearbyProjectsViewController.h"
#import "RCAddressController.h"
#import "RCToolbarController.h"

@interface RCAddressPageController()

@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property (strong, nonatomic) RCDevelopmentIndexViewController *developmentIndex;

@end

@implementation RCAddressPageController

- (void)updateBindings
{
    [self prepareControllers];
//    UIViewController <RCItemProtocol> *controller = [self currentViewController];
//    [controller updateBindings];
//    [self scrollToTop];
}

- (void)prepareData
{
    [self prepareControllers];
    [RCToolbarController setDisabledLoadAddressMode:YES];
    UIViewController <RCItemProtocol> *controller = [self currentViewController];
    [controller updateBindings];
    [self scrollToTop];
}

- (void)scrollToTop
{
    [[self currentViewController] scrollToTop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
   [self setScrollEnabled:NO];
 
    self.items = @[[self developmentIndex],[self forecastController], [self nearbyController]];
}

- (void)prepareAddressController
{
    @weakify(self);
    RCAddressController *controller = [RCAddressController shared];
    
    controller.didToolbarItemCellUpdatedBlock = ^(RCToolbarItemCell *toolbarItemCell,NSIndexPath *indexPath){
        @strongify(self);
        [self didToolbarItemCellUpdatedBlock:toolbarItemCell indexPath:indexPath];
    };
}

- (void)didToolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        toolbarItemCell.disabled = [RCToolbarController shared].disabledLoadAddressMode;
    }
}

- (void)scrollToMetrics
{
    [self prepareToolbarDevelopmentIndex];
    [self.developmentIndex scrollToMetrics];
}

- (void)prepareControllers
{
    [self prepareIndexController];
    [self prepareToolbar];
    [self prepareAddressController];
}

- (void)prepareToolbar
{
    [self prepareToolbarStateIndex];
    [self prepareToolbarDevelopmentIndex];
}

- (void)prepareToolbarStateIndex
{
    [RCToolbarController switchToolbarToState:RCMapToolbarViewStateIndex];
}

- (void)prepareToolbarDevelopmentIndex
{
    [RCAddressController selectIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
}

- (void)prepareIndexController
{
    [self indexController].didSelectIndexPath = ^(NSIndexPath *indexPath, BOOL animated){
        [self selectIndexPath:indexPath animated:animated];
    };
}

- (RCAddressController *)indexController
{
    return [RCAddressController shared];
}

- (void)selectIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    NSUInteger index = (NSUInteger)indexPath.row;
    NSArray *items = self.items;
    NSUInteger currentIndex = self.currentIndex;
    if (index >= items.count) {return;}
    if (index == currentIndex) {return;}
   
    UIPageViewControllerNavigationDirection direction = direction = index > currentIndex? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;;
    
    [self setViewControllers:@[self.items[index]]
                   direction:direction
                    animated:animated
                  completion:nil];
}

- (RCDevelopmentIndexViewController *)developmentIndex
{
    if (!_developmentIndex) {
        RCDevelopmentIndexViewController *indexController = [RCDevelopmentIndexViewController instantiateFromStoryboardNamed:@"DevelopmentIndex"];
        indexController.address = self.address;
        _developmentIndex = indexController;
    }
    return _developmentIndex;
}

- (NSUInteger)currentIndex
{
    return [self.items indexOfObject:[self currentViewController]];
}

- (UIViewController <RCItemProtocol>*)currentViewController
{
    return [self.viewControllers lastObject];
}

- (RCForecastViewController *)forecastController
{
    RCForecastViewController *forecastController = [RCForecastViewController instantiateFromStoryboardNamed:@"ForecastController"];
    forecastController.address = self.address;
    return forecastController;
}

- (RCDevelopmentIndexNearbyProjectsViewController *)nearbyController
{
    RCDevelopmentIndexNearbyProjectsViewController *nearbyController = [RCDevelopmentIndexNearbyProjectsViewController instantiateFromStoryboardNamed:@"DevelopmentIndex"];
    nearbyController.address = self.address;
    return nearbyController;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = scrollEnabled;
            return;
        }
    }
}

- (BOOL)canFullScreen
{
    BOOL result = [[self currentViewController] isKindOfClass:[RCDevelopmentIndexViewController class]];
    result = !result || (result && [AppState advancedVersion]);
    return result;
}

- (BOOL)canHalfScreen
{
    BOOL result = ![[self currentViewController] isKindOfClass:[RCForecastViewController class]];
    return result;
}

@end
