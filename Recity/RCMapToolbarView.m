//
//  RCMapToolbarView.m
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapToolbarView.h"
#import "RCButtonToolbarItemCell.h"
#import "RCProject.h"

@implementation RCMapToolbarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    self.didSelectedToolbarItemCellBlock = ^(RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath, BOOL selectedItemPressed) {
        @strongify(self);
        RUN_BLOCK(self.didToolbarViewItemSelectedBlock, indexPath.row, selectedItemPressed);
    };
}

- (void)switchStateToNormal {
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

- (void)switchStateToProjectDetails {
    self.state = RCMapToolbarViewStateDetails;
    self.itemCount = 3;
    self.toolbarItemCellForIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        RCButtonToolbarItemCell *result;
        result = [RCButtonToolbarItemCell createForCollectionView:collectionView indexPath:indexPath];
        result.autodeselectionEnabled = YES;
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

@end
