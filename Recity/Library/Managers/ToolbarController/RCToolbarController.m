//
//  RCToolbarController.m
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarController.h"

#import "RCButtonToolbarItemCell.h"

@interface RCToolbarController ()

@property (strong, nonatomic, readwrite) NSNumber *currentDevelopmentIndex;
@property (assign, nonatomic, readwrite) BOOL disabledLoadAddressMode;

@end

@implementation RCToolbarController
SINGLETON_OBJECT

- (void)setCurrentDevelopmentIndex:(NSNumber *)currentDevelopmentIndex
{
    _currentDevelopmentIndex = currentDevelopmentIndex;
}

+ (void)selectIndexPath:(NSIndexPath *)indexPath
{
    RUN_BLOCK([self controller].didSelectIndexPath,indexPath);
}

+ (void)selectPreviousItem {
    RUN_BLOCK([self controller].didSelectPreviousItem);
}

+ (void)selectIndexPathIfNormal:(NSIndexPath *)indexPath
{
   RUN_BLOCK([self controller].didSelectIndexPathIfNormal,indexPath);
}

+ (void)switchToolbarToState:(RCMapToolbarViewState)state
{
    RUN_BLOCK([self controller].didSwitchToolbarToState,state);
}

+ (void)resetSelectionAnimated:(BOOL)animated
{
    RUN_BLOCK([self controller].didResetSelectionAnimated,animated);
}

+ (RCToolbarController *)controller
{
    return [RCToolbarController  shared];
}

+ (void)eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow:(dispatch_block_t)completion
{
   RUN_BLOCK([self controller].didEraseUnfavoritedProjects,completion);
}

+ (RCToolbarItemCell *)toolbarItemCellForIndexPath:(NSIndexPath *)indexPath
{
    RCToolbarController *controller = [self controller];
    RCToolbarItemCell *result = nil;
    if(controller.toolbarItemCellForIndexPathBlock) {
        result = controller.toolbarItemCellForIndexPathBlock(indexPath);
    }
    return result;
}

+ (void)setDisabledLoadAddressMode:(BOOL)disabled
{
    RCToolbarController *controller = [self controller];
    controller.disabledLoadAddressMode = disabled;
    [controller reloadToolbarView];
}

+ (void)setIndexForDevelopmentIndexCell:(NSNumber *)index
{
    RCToolbarController *controller = [self controller];
    controller.currentDevelopmentIndex = index;
    NSIndexPath *indexPathForDevelopmentIndexCell = [NSIndexPath indexPathForRow:0
                                                                       inSection:0];
    RCToolbarItemCell *developmentIndexCell = [self toolbarItemCellForIndexPath:indexPathForDevelopmentIndexCell];
    [(RCButtonToolbarItemCell *)developmentIndexCell updateWithNewIndex:index];
    [controller reloadToolbarView];
}

- (void)reloadToolbarView
{
    RCMapToolbarViewState state = RCMapToolbarViewStateNormal;
    if(self.toolbarState) {
        state = self.toolbarState();
    }
    
    if(state == RCMapToolbarViewStateIndex) {
        RUN_BLOCK(self.reloadToolbar);
        
        NSIndexPath *currentIndexPathSelectedItem = nil;
        if(self.currentIndexPathSelectedItem) {
            currentIndexPathSelectedItem = self.currentIndexPathSelectedItem();
        }
        
        if(!currentIndexPathSelectedItem) {
            currentIndexPathSelectedItem = [NSIndexPath indexPathForRow:0
                                                              inSection:0];
        }
        
        RUN_BLOCK(self.didResetSelectionAnimated, NO);
        RUN_BLOCK(self.didSelectIndexPath, currentIndexPathSelectedItem);
    }
}

@end
