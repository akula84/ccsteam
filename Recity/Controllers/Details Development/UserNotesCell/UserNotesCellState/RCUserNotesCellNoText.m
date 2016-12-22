//
//  RCUserNotesCellNoText.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellNoText.h"

@implementation RCUserNotesCellNoText

- (CGFloat)calculateHeightCell
{
    return RCUserNotesCellMinHeightTextView + RCUserNotesCellBetweenContentView;
}

- (void)setupCell
{
    RCUserNotesCell *userNotesCell = self.userNotesCell;
    
    [userNotesCell setHiddenTopView:YES];
    [userNotesCell setHiddenBottomView:YES];
    
    [userNotesCell setHiddenBorderForTextNotesView:NO];
    userNotesCell.textNotesView.editable = NO;
    userNotesCell.textNotesView.scrollEnabled = NO;
    userNotesCell.editButtonInTextView.enabled = YES;
    
    [self setupHeightCell];
    userNotesCell.editButtonInTextViewToTop.constant = 0.f;
    userNotesCell.editButtonInTextViewToBottom.constant = 0.f;
    userNotesCell.textNotesViewToTop.constant = 0.f;
    userNotesCell.textNotesViewToBottom.constant = 0.f;
//    userNotesCell.textNotesHeight.constant = RCUserNotesCellMinHeightTextView;
}

@end
