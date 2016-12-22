//
//  RCUserNotesCellHasTextNotEqualUserNotesText.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellHasTextNotEqualUserNotesText.h"
#import "UIFont+RecityFont.h"

@implementation RCUserNotesCellHasTextNotEqualUserNotesText

- (CGFloat)calculateHeightText
{
    UIFont *font = [UIFont flamaBook13];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - RCUserNotesCellBetweenContentView - kCellInsets;
    
    CGFloat textNotesHeight = [self.userNotesCell.textEntered heightWithFont:font
                                                                       width:width];
    return textNotesHeight;
}

- (CGFloat)calculateHeightCell
{
    return RCUserNotesCellBetweenBottom + [self calculateHeightText] + RCUserNotesCellBetweenContentView;
}

- (void)setupCell
{
    RCUserNotesCell *userNotesCell = self.userNotesCell;
    
    [userNotesCell setHiddenTopView:YES];
    [userNotesCell setHiddenBottomView:NO];
    
    [userNotesCell setHiddenBorderForTextNotesView:NO];
    userNotesCell.textNotesView.editable = YES;
    userNotesCell.textNotesView.scrollEnabled = NO;
    
    [self setupHeightCell];
    userNotesCell.textNotesViewToTop.constant = 0.f;
    userNotesCell.textNotesHeight.constant = [self calculateHeightText];
    userNotesCell.textNotesViewToBottom.constant = RCUserNotesCellBetweenBottom;
}

@end
