//
//  RCUserNotesCellState.h
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCell_Private.h"

FOUNDATION_EXPORT const CGFloat RCUserNotesCellBetweenTop;
FOUNDATION_EXPORT const CGFloat RCUserNotesCellBetweenBottom;
FOUNDATION_EXPORT const CGFloat RCUserNotesCellMinHeightTextView;
FOUNDATION_EXPORT const CGFloat RCUserNotesCellBetweenContentView;
FOUNDATION_EXPORT const CGFloat RCUserNotesCellMaxHeightCell;

@interface RCUserNotesCellState : NSObject

+ (instancetype)stateUserNotesCellWithProject:(RCProject *)project;
+ (instancetype)stateUserNotesCellWithUserNotes:(RCUserNotes *)userNotes;
+ (instancetype)stateUserNotesCell:(RCUserNotesCell *)userNotesCell;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithUserNotes:(RCUserNotes *)userNotes NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithUserNotesCell:(RCUserNotesCell *)userNotesCell NS_DESIGNATED_INITIALIZER;

//One of the properties is empty. If userNotesCell != nil, then userNotes == nil, and vice versa.
@property (weak, nonatomic, readonly) RCUserNotesCell *userNotesCell;
@property (weak, nonatomic, readonly) RCUserNotes *userNotes;

- (CGFloat)calculateHeightCell;
- (CGFloat)calculateHeightText;
- (CGFloat)calculateHeightOneLineText;

- (void)setupCell;
- (void)setupHeightCell;

@end
