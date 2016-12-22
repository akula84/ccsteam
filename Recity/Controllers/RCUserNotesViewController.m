//
//  RCUserNotesViewController.m
//  Recity
//
//  Created by ezaji.dm on 01.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserNotesViewController.h"

#import "RCUserNotes.h"

@interface RCUserNotesViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextView *textNotesView;

@property (strong, nonatomic) RCUserNotes *userNotes;

@end

@implementation RCUserNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textNotesView becomeFirstResponder];
}

- (void)setupUI
{
    if(self.userNotes) {
        self.textNotesView.inputAccessoryView = self.deleteButton;
        self.textNotesView.text = self.userNotes.textNotes;
    }
    [self.saveButton setTitleColor:RGB(46, 49, 146)
                          forState:UIControlStateNormal];
    [self.saveButton setTitleColor:kDisabledButtonPurpleColor
                          forState:UIControlStateDisabled];
    [self checkEnabledSaveButton];
}

- (void)checkEnabledSaveButton
{
    if(self.textNotesView.text.length > 0) {
        self.saveButton.enabled = YES;
    
    } else {
        self.saveButton.enabled = NO;
        
    }
}

- (void)setProject:(RCProject *)project
{
    self.userNotes = [RCUserNotes userNotesForProject:project];
    _project = project;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkEnabledSaveButton];
}

- (IBAction)saveAction
{
    RCUser *user = [AppState sharedInstance].user;
    [user setNotesWithText:self.textNotesView.text
                forProject:self.project];
    
    [self cancelAction];
}

- (IBAction)cancelAction
{
    [self.textNotesView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)deleteAction
{
    RCUser *user = [AppState sharedInstance].user;
    [user deleteNotes:self.userNotes];
    
    [self cancelAction];
}

@end
