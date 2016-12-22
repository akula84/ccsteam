//
//  RCUserNotesCell.m
//  Recity
//
//  Created by ezaji.dm on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCell.h"
#import "RCUserNotesCell_Private.h"

#import "RCUserNotesCellState.h"

NSString *const RCUserNotesCellDidChangeStateNotification = @"RCUserNotesCellDidChangeStateNotification";

@interface RCUserNotesCell () <UITextViewDelegate>

@property (nonatomic) RCUserNotesCellState *state;

@end

@implementation RCUserNotesCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textEntered = nil;
}

- (void)configureCellState {
    self.state = [RCUserNotesCellState stateUserNotesCell:self];
}

- (void)setState:(RCUserNotesCellState *)state {
    if([_state class] != [state class]) {
        _state = state;
        [state setupCell];
        [[NSNotificationCenter defaultCenter] postNotificationName:RCUserNotesCellDidChangeStateNotification
                                                            object:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self configureCellState];
}

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length > 0) {
        self.saveButton.enabled = YES;
    } else {
        self.saveButton.enabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(![textView.text isEqualToString:self.userNotes.textNotes] && textView.text.length > 0)
        self.textEntered = textView.text;
    [self configureCellState];
}

- (void)setUserNotes:(RCUserNotes *)userNotes {
    if(self.textEntered && ![self.textEntered isEqualToString:userNotes.textNotes] && !self.textNotesView.isFirstResponder) {
        self.textNotesView.text = self.textEntered;
    } else {
        self.textEntered = nil;
        if(userNotes) {
            self.textNotesView.text = userNotes.textNotes;
            NSString *stringDate = [userNotes.lastModifiedAt stringValueWithFormat:@"MM/dd/yy"];
            self.lastModifiedLabel.text = [@"LAST MODIFIED: " stringByAppendingString:stringDate];
        } else {
            self.textNotesView.text = @"";
            self.lastModifiedLabel.text = @"";
        }
    }
    _userNotes = userNotes;
    [self configureCellState];
}

- (void)setHiddenTopView:(BOOL)hidden {
    self.lastModifiedLabel.hidden = hidden;
    self.editButton.hidden = hidden;
    self.editImageView.hidden = hidden;
}

- (void)setHiddenBottomView:(BOOL)hidden {
    self.saveButton.hidden = hidden;
    self.cancelButton.hidden = hidden;
    self.deleteButton.hidden = hidden;
}

- (void)setHiddenBorderForTextNotesView:(BOOL)hidden {
    self.textNotesView.isShowBorder = !hidden;
}

+ (CGFloat)height:(RCProject *)project {
    RCUserNotesCellState *state = [RCUserNotesCellState stateUserNotesCellWithProject:project];
    return [state calculateHeightCell];
}

+ (CGFloat)defaultHeight
{
    return RCUserNotesCellMinHeightTextView + RCUserNotesCellBetweenContentView;
}

@end
