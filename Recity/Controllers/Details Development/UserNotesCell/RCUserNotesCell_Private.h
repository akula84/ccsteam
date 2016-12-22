//
//  RCUserNotesCell_Private.h
//  Recity
//
//  Created by ezaji.dm on 22.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesCell.h"

@interface RCUserNotesCell ()

@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *editButtonInTextView;

@property (weak, nonatomic) IBOutlet UIImageView *editImageView;

//LayoutConstraint's
//Top
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textNotesViewToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonInTextViewToTop;

//Bottom
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textNotesViewToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonInTextViewToBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textNotesHeight;

- (void)setHiddenTopView:(BOOL)hidden;
- (void)setHiddenBottomView:(BOOL)hidden;
- (void)setHiddenBorderForTextNotesView:(BOOL)hidden;

@end
