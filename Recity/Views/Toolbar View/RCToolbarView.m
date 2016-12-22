//
//  BottomToolbarView.m
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarView_Protected.h"

#import "RCToolbarItemView.h"
#import "RCToolbarItemCell.h"
#import "RCButtonToolbarItemCell.h"

@implementation RCToolbarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UICollectionViewLayout *layout = [self collectionViewLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    [self addSubview:_collectionView];
    [RCButtonToolbarItemCell registerInCollectionView:_collectionView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

- (void)reloadAllData
{
    UICollectionViewLayout *layout = [self collectionViewLayout];
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView reloadData];
}

- (void)selectIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    self.selectedIndexPathsBeforeSelection = @[indexPath];
}

- (void)selectPreviousItem
{
    [self selectIndexPath:self.previousItemIndexPath];
}

- (void)resetSelectionAnimated:(BOOL)animated
{
    self.selectedIndexPathsBeforeSelection = nil;
    for (NSIndexPath *currentIndexPath in [self.collectionView indexPathsForVisibleItems]) {
        [self.collectionView deselectItemAtIndexPath:currentIndexPath animated:animated];
    }
}

- (UICollectionViewLayout *)collectionViewLayout
{
    UICollectionViewFlowLayout *result = [[UICollectionViewFlowLayout alloc] init];
    if (self.itemCount) {
        CGFloat count = self.itemCount;
        CGFloat width = self.width / count;
        NSInteger widthInteger = (NSInteger)width;
        [result setItemSize:CGSizeMake(widthInteger, self.height)];
    } else {
        [result setItemSize:CGSizeMake(40, 40)];//  default useless
    }
    result.minimumInteritemSpacing = 0.0;
    result.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return result;
}

#pragma mark - UICollectionViewDelegate DELEGATE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *result = self.toolbarItemCellForIndexPathBlock(self.collectionView, indexPath);
    result.selected = [self selectedItemPressed:indexPath];
    RUN_BLOCK(self.didToolbarItemCellUpdatedBlock, collectionView, (RCToolbarItemCell *)result, indexPath);
    return result;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCToolbarItemCell *cell = (RCToolbarItemCell*)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    BOOL selectedItemPressed = [self selectedItemPressed:indexPath];
    RUN_BLOCK(self.didSelectedToolbarItemCellBlock, cell, indexPath, selectedItemPressed);
    self.selectedIndexPathsBeforeSelection = [self.collectionView indexPathsForSelectedItems];
}

- (BOOL)selectedItemPressed:(NSIndexPath *)indexPath
{
    return [self.selectedIndexPathsBeforeSelection containsObject:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result;
    RCToolbarItemCell *cell = (RCToolbarItemCell*)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    result = !cell.disabled;
    return result;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result;
    RCToolbarItemCell *cell = (RCToolbarItemCell*)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    result = !cell.disabled;
    
    NSArray *indexPathsForSelectedItems = [collectionView indexPathsForSelectedItems];
    if(indexPathsForSelectedItems.isFull) {
        self.previousItemIndexPath = indexPathsForSelectedItems[0];
    }
    return result;
}

- (NSNumber *)currentSelectedIndex
{
    NSNumber *result;
    if (self.selectedIndexPathsBeforeSelection.count > 0) {
        NSIndexPath *indexPath = [self.selectedIndexPathsBeforeSelection firstObject];
        result = @(indexPath.row);
    }
    return result;
}

@end
