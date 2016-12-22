//
//  ContactUsPopupView.m
//  Recity
//
//  Created by Vitaliy Zhukov on 08.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "ContactUsPopupView.h"

#import "IQUITextFieldView+Additions.h"

#import "RCContactUsAPI.h"

@interface ContactUsPopupView() <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;
@property (weak, nonatomic) IBOutlet UIImageView *downArrow;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *successMessageLabel;

@property (strong, nonatomic) NSArray <NSString *> *reasons;

@property (strong, nonatomic) NSString *selectedReason;

@property (nonatomic) BOOL menuOpened;

@end

@implementation ContactUsPopupView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupTap];
    [self setupTable];
    [self setupMessageBox];
    [self updateSendButton];
}

- (NSArray<NSString *> *)reasons
{
    return @[@"General inquiry about the product", @"Technical support", @"Question about my account",
             @"Billing question", @"Suggest an edit to our data", @"Report a bug"];
}

- (void)setupTable
{
    self.tableHeightConstraint.constant = 0;
    UITableView *table = self.tableView;
    
    table.tableFooterView = [UIView new];
    table.layer.borderWidth = 1.0f;
    table.layer.borderColor = RGB(47, 49, 146).CGColor;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reasonCell"];
    [table reloadData];
}

- (void)setupMessageBox
{
    UITextView *messageBox = self.messageTextView;
    messageBox.layer.borderWidth = 1.0f;
    messageBox.layer.borderColor = RGB(47, 49, 146).CGColor;
    messageBox.delegate = self;
    messageBox.keyboardDistanceFromTextField = 70.0f;
}

- (IBAction)sendAction:(id)sender
{
    [self dismissKeyboard];
    NSString *message = self.messageTextView.text;
    if (self.selectedReason.isFull && message.isFull) {
        self.sendButton.enabled = NO;
        [RCContactUsAPI withObject:@{kContactUsMessage : message,
                                     kContactUsReason : self.selectedReason}
                        completion:^(id reply, NSError *error, BOOL *handleError)
        {
            if(!error) {
                [self setupSuccessMessage];
                self.sendButton.enabled = YES;
            }
        }];
    } else {
        NSLog(@"Need select reason and massage");
    }
}

- (void)setupSuccessMessage
{
    self.downArrow.hidden = YES;
    self.dropDownButton.hidden = YES;
    self.messageTextView.hidden = YES;
    self.separatorView.hidden = YES;
    self.messageLabel.hidden = YES;
    
    self.successMessageLabel.hidden = NO;
    [self.sendButton removeTarget:self
                           action:@selector(sendAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self
                        action:@selector(hideAnimated)
              forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitle:@"OK"
                     forState:UIControlStateNormal];
}

- (void)updateSendButton
{
    self.sendButton.enabled = self.selectedReason.isFull && self.messageTextView.text.isFull;
}

- (IBAction)toggleDropDown:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        if (self.menuOpened) {
            self.tableHeightConstraint.constant = 0;
            self.menuOpened = NO;
            self.downArrow.transform = CGAffineTransformIdentity;
        } else {
            self.tableHeightConstraint.constant = self.reasons.count * 44.0f;
            self.menuOpened = YES;
            self.downArrow.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
        }
        [self layoutIfNeeded];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.reasons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reasonCell" forIndexPath:indexPath];
    cell.textLabel.text = self.reasons[(NSUInteger)indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Flama-Book" size:13.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = self.reasons[(NSUInteger)indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self toggleDropDown:nil];
    self.selectedReason = reason;
    [self.dropDownButton setTitle:reason forState:UIControlStateNormal];
    [self updateSendButton];
}

- (void)setupTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.menuOpened) {
        [self toggleDropDown:nil];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateSendButton];
}

@end
