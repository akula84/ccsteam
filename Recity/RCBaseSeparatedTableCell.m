//
//  RCBaseSeparatedTableCell.m
//  Recity
//
//  Created by Matveev on 28/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

@implementation RCBaseSeparatedTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *separatorColor = RGB(230,230,230);
    self.selectedBackgroundColor = separatorColor;
    [self displaySeparatorsWithColor:separatorColor topSeparatorHeight:nil bottomSeparatorHeight:@1 displayWhenSelected:NO];
}

@end
