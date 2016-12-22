//
//  RCForecastViewController+ScrollDelegate.m
//  Recity
//
//  Created by Artem Kulagin on 18.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController_Private.h"

@implementation RCForecastViewController (ScrollDelegate)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging || scrollView.decelerating) {
        [self reloadTop];
        [self reloadCard];
        [self updateImageBackground];
        [self updateCells];
        [self checkMaxMinOffset];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self calculateMaxMinOffset];
}

- (void)checkMaxMinOffset
{
    if (!self.firstRunCompleted) {return;}
    UICollectionView *collectionView = self.collectionView;
    CGFloat offset = collectionView.contentOffset.x;
    CGFloat minOffset = self.minOffset;
    CGFloat maxOffset = self.maxOffset;
    
    if (offset < minOffset) {
        [collectionView setContentOffset:CGPointMake(minOffset, 0)];
    }
    
    if (maxOffset < offset) {
        [collectionView setContentOffset:CGPointMake(maxOffset, 0)];
    }
}

- (void)calculateMaxMinOffset
{
    CGFloat widthScreenHalf = self.widthScreenHalf;
    CGFloat minOffset = - widthScreenHalf;
    CGFloat maxOffset = MAXFLOAT;
    NSIndexPath *currentIndexPath = [self currentIndexPath];
    NSUInteger item = (NSUInteger)currentIndexPath.item;
    UICollectionView *collectionView = self.collectionView;
    
    if (item > 0) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:(NSInteger)(item - 1) inSection:0];
        minOffset = CGRectGetMidX([collectionView cellForItemAtIndexPath:index].frame) - widthScreenHalf;
    }
    
    if (item < (self.projects.count - 1)) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:(NSInteger)(item + 1) inSection:0];
        maxOffset = CGRectGetMidX([collectionView cellForItemAtIndexPath:index].frame) - widthScreenHalf;
    }
    self.minOffset = minOffset;
    self.maxOffset = maxOffset;
}

@end
