//
//  RCBaseSeparatedTableCell.m
//  Recity
//
//  Created by Matveev on 28/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

@implementation RCBaseSeparatedTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style
                   reuseIdentifier:reuseIdentifier]) {
        _showSeparatedBottom = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        _showSeparatedBottom = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if(_showSeparatedBottom) {
        UIColor *separatorColor = RGB(230,230,230);
        self.selectedBackgroundColor = separatorColor;
        [self displaySeparatorsWithColor:separatorColor topSeparatorHeight:nil bottomSeparatorHeight:@1 displayWhenSelected:NO];
    }
}

- (void)setShowSeparatedBottom:(BOOL)showSeparatedBottom
{
    if(showSeparatedBottom) {
        [self displaySeparatorsWithColor:RGB(230,230,230)
                      topSeparatorHeight:nil
                   bottomSeparatorHeight:@1
                     displayWhenSelected:NO];
    } else {
        [self displaySeparatorsWithColor:nil
                      topSeparatorHeight:nil
                   bottomSeparatorHeight:nil
                     displayWhenSelected:NO];
    }
    self->_showSeparatedBottom = showSeparatedBottom;
}

@end
