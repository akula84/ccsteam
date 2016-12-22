//
//  RCUserNotesHasText.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellHasText.h"

@implementation RCUserNotesCellHasText

- (CGFloat)calculateHeightCell
{
    //I don't know, why UITextView no visible two latest lines. This value is calculated experimental.
    return RCUserNotesCellBetweenTop + [self calculateHeightText] + 2 * [self calculateHeightOneLineText] + RCUserNotesCellBetweenContentView;
}

- (void)setupCell
{
    RCUserNotesCell *userNotesCell = self.userNotesCell;
    
    [userNotesCell setHiddenTopView:NO];
    [userNotesCell setHiddenBottomView:YES];
    
    [userNotesCell setHiddenBorderForTextNotesView:YES];
    userNotesCell.textNotesView.editable = NO;
    userNotesCell.textNotesView.scrollEnabled = NO;
    userNotesCell.editButtonInTextView.enabled = NO;
    
    [self setupHeightCell];
    userNotesCell.editButtonInTextViewToBottom.constant = 0.f;
    userNotesCell.textNotesViewToBottom.constant = 0.f;
//    userNotesCell.textNotesHeight.constant = RCUserNotesCellMinHeightTextView;
    userNotesCell.textNotesViewToTop.constant = RCUserNotesCellBetweenTop;
    userNotesCell.editButtonInTextViewToTop.constant = RCUserNotesCellBetweenTop;
}

@end
