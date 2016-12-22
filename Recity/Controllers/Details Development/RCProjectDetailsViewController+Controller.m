//
//  RCProjectDetailsViewController+Controller.m
//  Recity
//
//  Created by Artem Kulagin on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"

#import "RCDetailController.h"
#import "RCToolbarItemCell.h"

@implementation RCProjectDetailsViewController (Controller)

- (void)prepareDetailController
{
    @weakify(self);
    RCDetailController *controller = [RCDetailController shared];
    
    controller.didScrollToProjectDetailsSection = ^{
        @strongify(self);
        [self scrollToProjectDetailsSection];
    };
    
    controller.didPrepareToolbarFromStateDetails = ^(NSInteger toolbarViewItemIndex){
        @strongify(self);
        switch (toolbarViewItemIndex) {
            case 0: [self scrollToProjectDetailsSection];
                break;
                
            case 1: [self scrollToNotesSection];
                break;
                
            case 2: [self scrollToNearestSection];
                break;
                
            default:
                break;
        }
    };
    
    controller.didToolbarItemCellUpdatedBlock = ^(RCToolbarItemCell *toolbarItemCell,NSIndexPath *indexPath){
        @strongify(self);
        [self didToolbarItemCellUpdatedBlock:toolbarItemCell indexPath:indexPath];
    };
}

- (void)didToolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && ![self sectionWithTypeIsAvailable:DetailsSectionTypeDevelopmentDetails]) {
        toolbarItemCell.disabled = YES;
    }
    if (indexPath.row == 1 && ![self sectionWithTypeIsAvailable:DetailsSectionTypeNotes]) {
        toolbarItemCell.disabled = YES;
    }
    if (indexPath.row == 2 && ![self sectionWithTypeIsAvailable:DetailsSectionTypeNearbyDevelopments]) {
        toolbarItemCell.disabled = YES;
    }
}

@end
