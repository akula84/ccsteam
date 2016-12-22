//
//  RCMapViewController+Project.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCProjectDetailsViewController.h"
#import "RCProject.h"
#import "RCMapController.h"

@implementation RCMapViewController (ProjectDetails)

- (void)addProjectToHistory:(RCProject *)project
{
    if (project == [RCMapController selectedProject]) {
        return;
    }
    [self addRecentItem:project];
    [self showObjectInHistory:project];
}

- (RCProjectDetailsViewController *)detailsViewControllerForProject:(RCProject *)projectToAdd
{
    RCProjectDetailsViewController *detailsVC = [RCProjectDetailsViewController new];
    detailsVC.project = projectToAdd;
    
    return  detailsVC;
}

- (NSUInteger)indexInHistoryOfProject:(RCProject *)project
{
    for (UIViewController *vc in self.detailsHistory) {
        if ([vc isKindOfClass:[RCProjectDetailsViewController class]]) {
            RCProjectDetailsViewController *controller = (RCProjectDetailsViewController *)vc;
            if ([controller.project.uid isEqualToNumber:project.uid]) {
                return [self.detailsHistory indexOfObject:vc];
            }
        }
    }
    
    return NSNotFound;
}

@end
