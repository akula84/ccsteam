//
//  RCUserNotesNoTextEntryText.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellNoTextEntryText.h"

@implementation RCUserNotesCellNoTextEntryText

- (CGFloat)calculateHeightCell
{
    return RCUserNotesCellBetweenBottom + RCUserNotesCellMinHeightTextView + RCUserNotesCellBetweenContentView;
}

- (void)setupCell
{
    RCUserNotesCell *userNotesCell = self.userNotesCell;

    [userNotesCell setHiddenTopView:YES];
    [userNotesCell setHiddenBottomView:NO];
    userNotesCell.deleteButton.hidden = YES;
    
    [userNotesCell setHiddenBorderForTextNotesView:NO];
    userNotesCell.textNotesView.editable = YES;
    userNotesCell.textNotesView.scrollEnabled = YES;
    
    [self setupHeightCell];
    userNotesCell.textNotesViewToTop.constant = 0.f;
    userNotesCell.textNotesHeight.constant = RCUserNotesCellMinHeightTextView;
    userNotesCell.textNotesViewToBottom.constant = RCUserNotesCellBetweenBottom;
}

@end
