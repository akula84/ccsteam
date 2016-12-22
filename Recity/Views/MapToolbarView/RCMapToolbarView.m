//
//  RCMapToolbarView.m
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapToolbarView.h"
#import "RCMapToolbarView_Private.h"

#import "RCButtonToolbarItemCell.h"
#import "RCDetailController.h"
#import "RCAddressController.h"

@implementation RCMapToolbarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    @weakify(self);
    self.didSelectedToolbarItemCellBlock = ^(RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath, BOOL selectedItemPressed) {
        @strongify(self);
        [self didToolbarViewItemSelected:indexPath.row selectedItemPressed:selectedItemPressed];
    };
    
    self.didToolbarItemCellUpdatedBlock = ^(UICollectionView *collectionView, RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath) {
        @strongify(self);
        if (self.state == RCMapToolbarViewStateDetails) {
            [RCDetailController toolbarItemCellUpdatedBlock:toolbarItemCell indexPath:indexPath];
        } else if (self.state == RCMapToolbarViewStateIndex) {
            [RCAddressController toolbarItemCellUpdatedBlock:toolbarItemCell
                                                   indexPath:indexPath];
        }
    };
    
    [self prepareToolbarController];
}

- (void)switchStateToNormal
{
    self.state = RCMapToolbarViewStateNormal;
    self.itemCount = 3;
    self.toolbarItemCellForIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        RCButtonToolbarItemCell *result;
        result = [RCButtonToolbarItemCell createForCollectionView:collectionView indexPath:indexPath];
        result.autodeselectionEnabled = NO;
        switch (indexPath.row) {
            case 0:
                [result updateWithImage:IMG(@"recent_blue") selectedImage:IMG(@"recent_orange")];
                break;
            case 1:
                [result updateWithImage:IMG(@"favorite_blue") selectedImage:IMG(@"favorite_orange")];
                break;
            case 2:
                [result updateWithImage:IMG(@"nearest_blue") selectedImage:IMG(@"nearest_orange")];
                break;
                
            default:
                break;
        }
        return result;
    };
    [self reloadAllData];
}

- (void)switchStateToProjectDetails
{
    self.state = RCMapToolbarViewStateDetails;
    self.itemCount = 3;
    self.toolbarItemCellForIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        RCButtonToolbarItemCell *result;
        result = [RCButtonToolbarItemCell createForCollectionView:collectionView indexPath:indexPath];
        result.autodeselectionEnabled = NO;
        switch (indexPath.row) {
            case 0:
                [result updateWithImage:IMG(@"comment_blue") selectedImage:IMG(@"comment_orange")];
                break;
            case 1:
                [result updateWithImage:IMG(@"blank_list_blue") selectedImage:IMG(@"blank_list_orange")];
                break;
            case 2:
                [result updateWithImage:IMG(@"nearest_blue") selectedImage:IMG(@"nearest_orange")];
                break;
                
            default:
                break;
        }
        return result;
    };
    
    [self reloadAllData];
}

- (void)switchStateToDevelopmentIndex
{
    self.state = RCMapToolbarViewStateIndex;
    self.itemCount = 4;
    self.toolbarItemCellForIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        RCButtonToolbarItemCell *result;
        result = [RCButtonToolbarItemCell createForCollectionView:collectionView indexPath:indexPath];
        result.autodeselectionEnabled = NO;
        switch (indexPath.row) {
            case 0:
                if ([AppState advancedVersion]) {
                    [result updateWithImage:IMG(@"metrics_blue") selectedImage:IMG(@"metrics_orange")];
                } else {
                    [result updateWithIndex];
                }
                break;
            case 1:
                [result updateWithImage:IMG(@"crane_blue") selectedImage:IMG(@"crane_orange")];
                break;
            case 2:
                [result updateWithImage:IMG(@"nearest_blue") selectedImage:IMG(@"nearest_orange")];
                break;
            case 3: {
                [result updateWithImage:IMG(@"share_blue") selectedImage:[Utils image:IMG(@"share_blue") maskedByColor:RGB(244, 142, 38)]];
            }
                break;
                
            default:
                break;
        }
        return result;
    };
    
    [self reloadAllData];
}

- (void)switchToolbarToState:(RCMapToolbarViewState)state
{
    switch (state) {
        case RCMapToolbarViewStateNormal:
            [self switchStateToNormal];
            break;
        case RCMapToolbarViewStateDetails:
            [self switchStateToProjectDetails];
            break;
        case RCMapToolbarViewStateIndex:
            [self switchStateToDevelopmentIndex];
            break;
    }
}

@end
