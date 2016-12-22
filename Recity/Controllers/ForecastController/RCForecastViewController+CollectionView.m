//
//  RCForecastViewController+CollectionView.m
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController_Private.h"

#import "RCForecastCell.h"
#import "RCProject.h"

static CGFloat heightTopView = 70.f;
static CGFloat heightDownView = 193.f;
static CGFloat heightBar = 35.f;

@implementation RCForecastViewController (CollectionView)

- (void)nextCell
{
    NSIndexPath *currentIndex = [self currentIndexPath];
    NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:currentIndex.item + 1 inSection:currentIndex.section];
    if ((NSUInteger)nextIndex.item >= self.projects.count) {return;}
    [self setIndexPath:nextIndex];
}

- (void)backCell
{
    NSIndexPath *currentIndex = [self currentIndexPath];
    NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:currentIndex.item - 1 inSection:currentIndex.section];
    if (nextIndex.item < 0) {return;}
    [self setIndexPath:nextIndex];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    [self setIndexPath:indexPath animated:YES];
}

- (void)setIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self calculateMaxMinOffset];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    CGPoint point = CGPointMake(CGRectGetMidX(cellRect) - self.widthScreenHalf, 0);
    [self startChangeProject:point animated:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)self.projects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCProject *item = self.projects[(NSUInteger)indexPath.row];
    RCForecastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RCForecastCell rc_className] forIndexPath:indexPath];
    [cell setItem:item estimateFloor:[self estimateFloor]];
    return cell;
}

- (void)updateCellHeightImageWithNewContentOffset:(CGPoint)contentOffset
{
    NSArray *array = [self.collectionView visibleCells];
    for (RCForecastCell *cell in array) {
        [cell updateHeightWithOffset:contentOffset];
    }
}

- (void)updateCellsAlfaCenter
{
    UICollectionView *collectionView = self.collectionView;
    NSArray *array = [collectionView visibleCells];
    NSIndexPath *currentIndexPath = [self currentIndexPath];
    for (RCForecastCell *cell in array) {
        NSIndexPath *index = [collectionView indexPathForCell:cell];
        [cell setCenterAlfa:[index isEqual:currentIndexPath]];
    }
}

- (void)updateCells
{
    
    [self updateCellsAlfaCenter];
    [self updateCellHeightImageWithNewContentOffset:self.collectionView.contentOffset];
}

- (NSIndexPath *)currentIndexPath
{
    UICollectionView *collectionView = self.collectionView;
    CGPoint point = collectionView.contentOffset;
    point.x =  point.x + self.widthScreenHalf;
    return [collectionView indexPathForItemAtPoint:point];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCProject *item = self.projects[(NSUInteger)indexPath.item];
    CGFloat width =  [self widthCellFrom:item];
    return CGSizeMake(width, [self heightCollectonView]);
}

- (void)prepareHeightCollectionView
{
    CGFloat heightScreen = [self screenSize].height;
    CGFloat heightDown = heightDownView * self.widthScreen/320.f;
    self.heightCollectionConstraint.constant = heightScreen - heightDown - heightTopView - heightBar - self.statusBarHeight;
}

- (CGFloat)statusBarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)heightCollectonView
{
    return self.heightCollectionConstraint.constant - heightTopView;
}

- (CGFloat)heightScreenHalf
{
    return [self widthScreen]/2;
}

- (void)prepareContentInset
{
    CGFloat widthScreenHalf = self.widthScreenHalf;
    NSArray *projects = self.projects;
    CGFloat left =  widthScreenHalf - [self widthCellFrom:projects.firstObject]/2;
    CGFloat right =  widthScreenHalf - [self widthCellFrom:projects.lastObject]/2;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, left, 0, right);
}

- (CGFloat)widthCellFrom:(RCProject *)item
{
    return [RCForecastCell widthWith:item estimateFloor:[self estimateFloor] heightCell:[self heightCollectonView]];
}

@end
