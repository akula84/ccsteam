//
//  BaseTableCell.m
//  golf-fitness
//
//  Created by Matveev on 04.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RCBaseTableCell.h"
#import "SeparatorView.h"

static UIColor *_defaultSelectionColorSTATIC;

@interface RCBaseTableCell ()

@property (strong, nonatomic) UIView *topSeparatorView;
@property (strong, nonatomic) UIView *bottomSeparatorView;
@property (strong, nonatomic) UIView *selectedTopSeparatorView;
@property (strong, nonatomic) UIView *selectedBottomSeparatorView;
@property (strong, nonatomic) NSNumber *topSeparatorHeight;
@property (strong, nonatomic) NSNumber *bottomSeparatorHeight;

@end

@implementation RCBaseTableCell

+ (void)setDefaultSelectionColor:(UIColor *)color {
    _defaultSelectionColorSTATIC = color;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectedBackgroundColor:_defaultSelectionColorSTATIC];    
}

- (void)setSelectedBackgroundColor:(UIColor *)color {
    _selectedBackgroundColor = color;
    UIView *backgroundColorView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundColorView.backgroundColor = color;
    [self setSelectedBackgroundView:backgroundColorView];
}

- (void)displaySeparatorsWithColor:(UIColor *)color topSeparatorHeight:(NSNumber *)topSeparatorHeight bottomSeparatorHeight:(NSNumber *)bottomSeparatorHeight displayWhenSelected:(BOOL)displayWhenSelected {//       change mode of cell
//    [self setSelectedBackgroundColor:[UIColor whiteColor]];
    if (_topSeparatorView) {
        [_topSeparatorView removeFromSuperview];
    }
    if (_bottomSeparatorView) {
        [_bottomSeparatorView removeFromSuperview];
    }
    if (self.selectedTopSeparatorView) {
        [self.selectedTopSeparatorView removeFromSuperview];
    }
    if (self.selectedBottomSeparatorView) {
        [self.selectedBottomSeparatorView removeFromSuperview];
    }
    
    self.topSeparatorHeight = topSeparatorHeight;
    self.bottomSeparatorHeight = bottomSeparatorHeight;
    
    self.topSeparatorView = [self separatorViewWithSeparatorHeight:topSeparatorHeight color:color];
    self.selectedTopSeparatorView = [self separatorViewWithSeparatorHeight:topSeparatorHeight color:color];
    
    self.bottomSeparatorView = [self separatorViewWithSeparatorHeight:bottomSeparatorHeight color:color];
    self.selectedBottomSeparatorView = [self separatorViewWithSeparatorHeight:bottomSeparatorHeight color:color];
    
    if (self.topSeparatorView) {
        [self.contentView insertSubview:self.topSeparatorView atIndex:0];
    }
    if (displayWhenSelected && self.selectedTopSeparatorView) {
        [self.selectedBackgroundView addSubview:self.selectedTopSeparatorView];
    }
    
    if (self.bottomSeparatorView) {
        [self.contentView insertSubview:self.bottomSeparatorView atIndex:0];
    }
    if (displayWhenSelected && self.selectedBottomSeparatorView) {
        [self.selectedBackgroundView addSubview:self.selectedBottomSeparatorView];
    }
    
//    _topSeparatorView.hidden = topSeparatorHeight == nil;
//    _bottomSeparatorView.hidden = bottomSeparatorHeight == nil;
}

- (UIView *)separatorViewWithSeparatorHeight:(NSNumber *)separatorHeight color:(UIColor *)color {
    UIView *result;
    BOOL topSeparatorHeightIsMostThinLine = [Utils floatNumber:separatorHeight.doubleValue isEqualToFloatNumber:[Utils mostThinLineWidth]];
    if (topSeparatorHeightIsMostThinLine) {
        result = [SeparatorView new];
        result.contentMode = UIViewContentModeTop;
    } else {
        result = [UIView new];
    }
    result.backgroundColor = color;
    return result;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.topSeparatorHeight) {
        self.topSeparatorView.frame = CGRectMake(self.separatorInset.left, 0, self.contentView.width, self.topSeparatorHeight.doubleValue);//      self.separatorInset automatically filled by parent UITableView of this cell
        self.selectedTopSeparatorView.frame = CGRectMake(self.separatorInset.left, 0.5, self.contentView.width - self.separatorInset.left - self.separatorInset.right, self.topSeparatorHeight.doubleValue);
    }
    if (self.bottomSeparatorHeight) {
        self.bottomSeparatorView.frame = CGRectMake(self.separatorInset.left, self.contentView.height - self.bottomSeparatorHeight.doubleValue, self.contentView.width, self.bottomSeparatorHeight.doubleValue);
        self.selectedBottomSeparatorView.frame = CGRectMake(self.separatorInset.left, 0.5 + self.contentView.height - self.bottomSeparatorHeight.doubleValue, self.contentView.width - self.separatorInset.left - self.separatorInset.right, self.bottomSeparatorHeight.doubleValue);
    }
    self.contentView.width = self.width - (self.contentViewInsets.left + self.contentViewInsets.right);
    self.contentView.height = self.height - (self.contentViewInsets.top + self.contentViewInsets.bottom);
    self.contentView.x = self.contentViewInsets.left;
    self.contentView.y = self.contentViewInsets.top;
}

@end
