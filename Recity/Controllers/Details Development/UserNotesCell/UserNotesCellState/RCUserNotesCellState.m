//
//  RCUserNotesCellState.m
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCellState.h"

#import "RCUserNotesCellNoText.h"
#import "RCUserNotesCellHasText.h"
#import "RCUserNotesCellNoTextEntryText.h"
#import "RCUserNotesCellHasTextEntryText.h"
#import "RCUserNotesCellHasTextNotEqualUserNotesText.h"

#import "RCKeyBoardManager.h"
#import "UIFont+RecityFont.h"

const CGFloat RCUserNotesCellBetweenTop = 39.f;
const CGFloat RCUserNotesCellBetweenBottom = 29.f;
const CGFloat RCUserNotesCellMinHeightTextView = 80.f;
const CGFloat RCUserNotesCellBetweenContentView = 16.f;
const CGFloat RCUserNotesCellMaxHeightCell = 165.f;

@interface RCUserNotesCellState ()

@property (weak, nonatomic, readwrite) RCUserNotesCell *userNotesCell;
@property (weak, nonatomic ,readwrite) RCUserNotes *userNotes;

@end

@implementation RCUserNotesCellState

+ (Class)stateClassWithUserNotes:(RCUserNotes *)userNotes
{
    Class result = nil;
    RCKeyBoardManager *keyboardManager = [RCKeyBoardManager shared];
    if(keyboardManager.showKeyboard)
    {
        if(userNotes.textNotes.length > 0)
        {
            result = [RCUserNotesCellHasTextEntryText class];
        } else {
            result = [RCUserNotesCellNoTextEntryText class];
        }
    } else {
        if(userNotes.textNotes.length > 0)
        {
            result = [RCUserNotesCellHasText class];
        } else {
            result = [RCUserNotesCellNoText class];
        }
    }
    return result;
}

+ (instancetype)stateUserNotesCellWithProject:(RCProject *)project
{
    return [self stateUserNotesCellWithUserNotes:[RCUserNotes userNotesForProject:project]];
}

+ (instancetype)stateUserNotesCellWithUserNotes:(RCUserNotes *)userNotes
{
    Class classResult = [self stateClassWithUserNotes:userNotes];
    return [[classResult alloc] initWithUserNotes:userNotes];
}

+ (instancetype)stateUserNotesCell:(RCUserNotesCell *)userNotesCell {
    RCUserNotesCellState *result = nil;
    RCKeyBoardManager *keyboardManager = [RCKeyBoardManager shared];
    if(userNotesCell.textEntered && ![userNotesCell.textEntered isEqualToString:userNotesCell.userNotes.textNotes] && !keyboardManager.showKeyboard) {
        result = [[RCUserNotesCellHasTextNotEqualUserNotesText alloc] initWithUserNotesCell:userNotesCell];
    } else {
        result = [self stateUserNotesCellWithUserNotes:userNotesCell.userNotes];
        result.userNotesCell = userNotesCell;
    }
    return result;
}

- (instancetype)initWithUserNotes:(RCUserNotes *)userNotes
{
    if(self = [super init])
    {
        _userNotes = userNotes;
    }
    return self;
}

- (instancetype)initWithUserNotesCell:(RCUserNotesCell *)userNotesCell
{
    if(self = [super init])
    {
        _userNotesCell = userNotesCell;
    }
    return self;
}

- (CGFloat)calculateHeightCell
{
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (CGFloat)calculateHeightText
{
    UIFont *font = [UIFont flamaBook13];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - RCUserNotesCellBetweenContentView - kCellInsets;
    
    RCUserNotes *userNotes = (_userNotes) ? _userNotes : _userNotesCell.userNotes;
    CGFloat textNotesHeight = [userNotes.textNotes heightWithFont:font
                                                            width:width];
    return textNotesHeight;
}

- (CGFloat)calculateHeightOneLineText {
    UIFont *font = [UIFont flamaBook13];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - RCUserNotesCellBetweenContentView - kCellInsets;
    
    CGFloat oneLineHeight = [@"OneLine" heightWithFont:font
                                                 width:width];
    return oneLineHeight;
}

- (void)setupCell
{
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (void)setupHeightCell
{
    RCUserNotesCell *userNotesCell = self.userNotesCell;
    CGFloat heightCell = [self calculateHeightCell];
    if(heightCell > userNotesCell.height) {
        userNotesCell.height = heightCell;
    }
}

- (void)setUserNotes:(RCUserNotes *)userNotes
{
    self->_userNotes = userNotes;
    self->_userNotesCell = nil;
}

- (void)setUserNotesCell:(RCUserNotesCell *)userNotesCell
{
    self->_userNotesCell = userNotesCell;
    self->_userNotes = nil;
}

@end
