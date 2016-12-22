//
//  RCMapToolbarView+Controller.m
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapToolbarView_Private.h"

@implementation RCMapToolbarView (Controller)

- (void)prepareToolbarController
{
    @weakify(self);
    RCToolbarController *toolbarController = [RCToolbarController shared];
    toolbarController.didSelectIndexPath = ^(NSIndexPath *indexPath){
        @strongify(self);
        [self selectIndexPath:indexPath];
    };
    
    toolbarController.didSelectPreviousItem = ^() {
        @strongify(self);
        [self selectPreviousItem];
    };
    
    toolbarController.didSwitchToolbarToState = ^(RCMapToolbarViewState state){
        @strongify(self);
        [self switchToolbarToState:state];
    };
    
    toolbarController.didResetSelectionAnimated = ^(BOOL animated){
        @strongify(self);
         [self resetSelectionAnimated:animated];
    };
    
    toolbarController.didSelectIndexPathIfNormal = ^(NSIndexPath *indexPath){
        @strongify(self);
        if (self.state == RCMapToolbarViewStateNormal) {
            [self selectIndexPath:indexPath];
        }
    };
    
    toolbarController.didEraseUnfavoritedProjects = ^(dispatch_block_t completion){
        @strongify(self);
        NSNumber *currentSelectedIndex = [self currentSelectedIndex];
        if (currentSelectedIndex) {
            BOOL willEraseUnfavoritedProjects = self.state == RCMapToolbarViewStateNormal && currentSelectedIndex.integerValue != 1;
            if (willEraseUnfavoritedProjects) {
                RUN_BLOCK(completion);
            }
        }
    };
    
    toolbarController.toolbarItemCellForIndexPathBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        RCToolbarItemCell *result = nil;
        if(self.toolbarItemCellForIndexPathBlock) {
            result = self.toolbarItemCellForIndexPathBlock(self.collectionView, indexPath);
        }
        return result;
    };
    
    toolbarController.currentIndexPathSelectedItem = ^ {
        @strongify(self);
        NSArray *indexPaths = self.selectedIndexPathsBeforeSelection;
        NSIndexPath *result = nil;
        if(indexPaths.isFull) {
            result = indexPaths.lastObject;
        }
        return result;
    };
    
    toolbarController.reloadToolbar = ^ {
        @strongify(self);
        [self reloadAllData];
    };
    
    toolbarController.toolbarState = ^ {
        @strongify(self);
        return self.state;
    };
}

@end
