//
//  RCDetailController.m
//  Recity
//
//  Created by Artem Kulagin on 13.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDetailController.h"
#import "RCToolbarController.h"

#import "RCFloatViewSliderController.h"

@implementation RCDetailController
SINGLETON_OBJECT

- (void)prepareSingleton
{
    self.selectedSectionType = -1;
}

+ (void)scrollToProjectDetailsSection
{
    RUN_BLOCK([self controller].didScrollToProjectDetailsSection)
}

+ (void)prepareToolbarFromStateDetails:(NSInteger)toolbarViewItemIndex
{
    [RCFloatViewSliderController displayFullscreenIfHalf:^{
        RUN_BLOCK([self controller].didPrepareToolbarFromStateDetails,toolbarViewItemIndex);
    }];
}

+ (void)toolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath
{
    RUN_BLOCK([self controller].didToolbarItemCellUpdatedBlock,toolbarItemCell,indexPath);
}

+ (void)selectDevelopmentDetailsSection
{
    [self selectSectionByIndex:0];
}

+ (void)selectUserNotesSection
{
    [self selectSectionByIndex:1];
}

+ (void)selectNearbySection
{
    [self selectSectionByIndex:2];
}

+ (void)selectSectionByIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [RCToolbarController selectIndexPath:indexPath];
}

+ (void)selectSectionWithType:(DetailsSectionType)sectionType
{
    RCDetailController *detailController = [self controller];
    if(sectionType != detailController.selectedSectionType) {
        detailController.selectedSectionType = sectionType;
        switch (sectionType) {
            case DetailsSectionTypeDevelopmentDetails:
                [self selectDevelopmentDetailsSection];
                break;
            case DetailsSectionTypeNotes:
                [self selectUserNotesSection];
                break;
            case DetailsSectionTypeNearbyDevelopments:
                [self selectNearbySection];
                break;
            default:
                break;
        }
    }
}

+ (void)resetSelectionSection
{
    [self controller].selectedSectionType = -1;
    [RCToolbarController resetSelectionAnimated:NO];
}

+ (RCDetailController *)controller
{
    return [RCDetailController shared];
}

@end
