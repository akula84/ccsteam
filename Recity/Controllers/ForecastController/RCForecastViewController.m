//
//  RCForecastViewController.m
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController.h"
#import "RCForecastViewController_Private.h"

#import "RCToolbarController.h"
#import "RCProject.h"
#import "RCAddress.h"
#import "RCPredicateFactory.h"
#import "RCFloatViewSliderController.h"
#import "RCKVCHelper.h"

@implementation RCForecastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self registerNotifications:NO];
    
    [super viewWillDisappear:animated];
}

- (void)registerNotifications:(BOOL)enable
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSString *name = UIApplicationDidChangeStatusBarFrameNotification;
    if (enable) {
        [center addObserver:self selector:@selector(didChangeStatusBarFrame) name:name object:nil];
    } else {
        [center removeObserver:self name:name object:nil];
    }
}

- (void)didChangeStatusBarFrame
{
    [self reloadCollectionView];
}

- (void)reloadCollectionView
{
    self.firstRunCompleted = NO;
    [self prepareHeightCollectionView];
    [self loadItems];
}

- (void)loadLastCompletedProject
{
    NSUInteger index = 0;
    NSArray *projects = self.projects;
    NSArray *projectCompleted = [projects filteredArrayUsingPredicate:[RCPredicateFactory predCompleted]];
    if (projectCompleted) {
        RCProject *lastProject = projectCompleted.lastObject;
        index = [projects indexOfObject:lastProject];
        if (projects.count > projectCompleted.count) {
            index = index + 1;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(NSInteger)index inSection:0];
    [self setIndexPath:indexPath animated:NO];
    self.firstRunCompleted = YES;
}

- (void)scrollToTop{}

- (void)updateBindings{}

- (void)loadItems
{
    self.projects = [self sortedProjects];

    if (!self.projects.isFull) {
        [self prepareNoData];
        return;
    }
    
    [self prepareContentInset];
    dispatch_main_async(^{
        [self.collectionView reloadData];
        [self loadLastCompletedProject];
    });
}

- (NSArray <RCProject *> *)sortedProjects
{
    NSArray *array = [RCProject nearbyProjectsToPoint:[self.address coordinate]];
    NSPredicate *pred = [RCPredicateFactory predCompletionDateNull];
    NSArray *arrayNil = [array filteredArrayUsingPredicate:pred];
    
    NSMutableArray *sortedArray = [array mutableCopy];
    [sortedArray removeObjectsInArray:arrayNil];
    
    [sortedArray sortUsingComparator:^NSComparisonResult(RCProject *_Nonnull leftProject, RCProject *_Nonnull rightProject)
     {
         NSComparisonResult comparisonResult;
         NSInteger completionYearForLeftProject = leftProject.completionYear;
         NSInteger completionYearForRightProject = rightProject.completionYear;
         if(completionYearForLeftProject < completionYearForRightProject) {
             comparisonResult = NSOrderedAscending;
         } else if(completionYearForLeftProject > completionYearForRightProject) {
             comparisonResult = NSOrderedDescending;
         } else {
             RCYearPeriod yearPeriodForLeftProject = [RCTransformer yearPeriodWithString:leftProject.completionTime];
             RCYearPeriod yearPeriodForRightProject = [RCTransformer yearPeriodWithString:rightProject.completionTime];
             if(yearPeriodForLeftProject < yearPeriodForRightProject) {
                 comparisonResult = NSOrderedAscending;
             } else if(yearPeriodForLeftProject > yearPeriodForRightProject) {
                 comparisonResult = NSOrderedDescending;
             } else {
                 comparisonResult = NSOrderedSame;
             }
         }
         
         return comparisonResult;
     }];
    
    return [sortedArray arrayByAddingObjectsFromArray:arrayNil];
}

- (CGFloat)widthScreenHalf
{
    return [self widthScreen]/2;
}

- (CGFloat)widthScreen
{
    return [self screenSize].width;
}

- (CGSize)screenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

- (RCProject *)currentProject
{
    return self.projects[(NSUInteger)self.currentIndexPath.item];
}

- (NSNumber *)estimateFloor
{
    return [RCKVCHelper avgForKey:kFloorCount item:self.projects];
}

@end
