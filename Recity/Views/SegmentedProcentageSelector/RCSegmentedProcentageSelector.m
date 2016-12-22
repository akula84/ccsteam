//
//  RCSegmentedProcentageSelector.m
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSegmentedProcentageSelector.h"

#import "RCSegmentedSelectorCollectionViewCell.h"

static const CGFloat minimalSectionWidth = 25.0f;

@interface RCSegmentedProcentageSelector() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (nonatomic) CGFloat diffCompensation;

@property (strong, nonatomic) NSMutableArray <NSNumber *> *cellWidths;

@end

@implementation RCSegmentedProcentageSelector

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
        
        self.selectedIndex = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateUI];
}

- (void)setValues:(NSArray<NSNumber *> *)values
{
    _values = values;
    [self updateUI];
}

- (void)calculateSizes
{
    CGFloat overallWidth = CGRectGetWidth(self.bounds) - 44.0f;
    CGFloat pointsInPercent = overallWidth / 100.0f;
    
    NSMutableArray *widths = [NSMutableArray array];
    CGFloat diffSumm = 0.0f;
    NSUInteger littleCount = 0;
    
    for (NSNumber *value in self.values) {
        CGFloat width = value.floatValue * pointsInPercent;
        
        if (width < minimalSectionWidth * 1.5f) {
            CGFloat diff = minimalSectionWidth - width;
            width += diff;
            diffSumm += diff;
            littleCount ++;
        }
        
        [widths addObject:@(width)];
    }
    
    CGFloat diffDevided = diffSumm / (widths.count - littleCount);
    
    NSMutableArray *fixedWidths = [NSMutableArray array];
    
    for (NSNumber *value in widths) {
        NSNumber *fixedWidth = @(value.floatValue);
        if (value.floatValue > minimalSectionWidth * 1.5f) {
            fixedWidth = @(value.floatValue - diffDevided);
        }
        [fixedWidths addObject:fixedWidth];
    }
    
    self.cellWidths = [fixedWidths copy];
}


- (void)updateUI
{
    [self calculateSizes];
    [self.collectionView reloadData];
}

- (void)setupViews
{
    for (UIView *view in [[self.subviews firstObject] subviews]) {
        
        switch (view.tag) {
            case 10:{
                UIButton *button = (UIButton *)view;
                [button addTarget:self action:@selector(selectPrevious) forControlEvents:UIControlEventTouchUpInside];
                self.backButton = button;
                break;
            }
            case 20:{
                UICollectionView *collection = (UICollectionView *)view;
                [collection registerNib:[UINib nibWithNibName:@"RCSegmentedSelectorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"segmentCell"];
                collection.dataSource = self;
                collection.delegate = self;
                [collection reloadData];
                self.collectionView = collection;
                break;
            }
            case 30:{
                UIButton *button = (UIButton *)view;
                [button addTarget:self action:@selector(selectNext) forControlEvents:UIControlEventTouchUpInside];
                self.forwardButton = button;
                break;
            }
           
            default:
                break;
        }
    }
}

- (void)selectNext
{
    self.selectedIndex++;
}

- (void)selectPrevious
{
    self.selectedIndex--;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex == 0) {
        _selectedIndex = 0;
        self.backButton.hidden = YES;
        self.forwardButton.hidden = NO;
    } else if (selectedIndex >= self.values.count - 1) {
        _selectedIndex = self.values.count - 1;
        self.backButton.hidden = NO;
        self.forwardButton.hidden = YES;
    } else {
        _selectedIndex = selectedIndex;
        self.backButton.hidden = NO;
        self.forwardButton.hidden = NO;
    }
    
    [self.delegate segmentedSelectorDidSelectSegmentAtIndex:_selectedIndex];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)self.values.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *width = self.cellWidths[(NSUInteger)indexPath.row];
    
    return CGSizeMake(width.floatValue, 32.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segmentCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(RCSegmentedSelectorCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.current = ((NSUInteger)indexPath.row == self.selectedIndex);
    cell.selectionColor = self.selectionColor;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = (NSUInteger)indexPath.row;
}

- (NSNumber *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.values[(NSUInteger)indexPath.row];
}

@end
