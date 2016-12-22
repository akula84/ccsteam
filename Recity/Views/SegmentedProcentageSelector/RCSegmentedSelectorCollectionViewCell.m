//
//  RCSegmentedSelectorCollectionViewCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSegmentedSelectorCollectionViewCell.h"

@interface RCSegmentedSelectorCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIView *barView;

@end

@implementation RCSegmentedSelectorCollectionViewCell

- (void)setSelected:(BOOL)selected
{}

- (void)setCurrent:(BOOL)current
{
    _current = current;
    
    self.arrowView.hidden = !current;
    
    [self updateColors];
}

- (void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    [self updateColors];
}

- (void)updateColors
{
    self.barView.backgroundColor = self.current ? self.selectionColor : RGB(230, 230, 230);
    self.arrowView.tintColor = self.barView.backgroundColor;
}

@synthesize selectionColor = _selectionColor;

- (UIColor *)selectionColor
{
    if (!_selectionColor) {
        _selectionColor = RGB(230, 230, 230);
    }
    return _selectionColor;
}

@end
