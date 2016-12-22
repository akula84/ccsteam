//
//  BottomToolbarView.h
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarItemCell.h"

typedef void(^DidSelectedToolbarItemCellBlock)(RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath, BOOL selectedItemPressed);
typedef RCToolbarItemCell *(^ToolbarItemCellForIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^ToolbarItemCellBlock)(UICollectionView *collectionView, RCToolbarItemCell *toolbarItemCell, NSIndexPath *indexPath);

@interface RCToolbarView : UIView

@property (assign, nonatomic) NSInteger itemCount;

@property (strong, nonatomic) ToolbarItemCellForIndexPathBlock toolbarItemCellForIndexPathBlock;
@property (strong, nonatomic) DidSelectedToolbarItemCellBlock didSelectedToolbarItemCellBlock;
@property (strong, nonatomic) ToolbarItemCellBlock didToolbarItemCellUpdatedBlock;

- (void)reloadAllData;
- (void)selectIndexPath:(NSIndexPath *)indexPath;
- (void)selectPreviousItem;
- (void)resetSelectionAnimated:(BOOL)animated;
- (NSNumber *)currentSelectedIndex;

@end
