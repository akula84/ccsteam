//
//  RCUserNotesCell.h
//  Recity
//
//  Created by ezaji.dm on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableCell.h"

#import "RCPlaceholderTextView.h"

#import "RCUserNotes.h"

FOUNDATION_EXPORT NSString *const RCUserNotesCellDidChangeStateNotification;

@interface RCUserNotesCell : RCBaseTableCell

@property (weak, nonatomic) IBOutlet RCPlaceholderTextView *textNotesView;
@property (nonatomic, copy) NSString *textEntered;

@property (strong, nonatomic) RCUserNotes *userNotes;

+ (CGFloat)height:(RCProject *)project;
+ (CGFloat)defaultHeight;

@end
