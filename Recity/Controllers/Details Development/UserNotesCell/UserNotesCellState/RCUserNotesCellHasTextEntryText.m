//
//  RCUserNotesCellHasTextEntryText.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellHasTextEntryText.h"

@implementation RCUserNotesCellHasTextEntryText

- (CGFloat)calculateHeightText
{
    return ([super calculateHeightText] > RCUserNotesCellMinHeightTextView) ? [super calculateHeightText] : RCUserNotesCellMinHeightTextView;
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
    userNotesCell.textNotesView.scrollEnabled = YES;
    
    [self setupHeightCell];
    userNotesCell.textNotesViewToTop.constant = 0.f;
    userNotesCell.textNotesHeight.constant = [self calculateHeightText];
    userNotesCell.textNotesViewToBottom.constant = RCUserNotesCellBetweenBottom;
}

@end
