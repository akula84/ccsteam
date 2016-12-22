//
//  RCAdditionalTenantTableCell.m
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAdditionalTenantTableCell.h"

@interface RCAdditionalTenantTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation RCAdditionalTenantTableCell

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setHidden:NO];
    [self setPlaceholedText:@"Type in a New Tenant"];
    self.model.image = [Utils circleImageWithRadius:17.5f
                                    backgroundColor:RGB(46, 49, 146)
                                              image:IMG(@"add_suggestion")];
    [super setModel:self.model];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setHidden:YES];
    [self setPlaceholedText:@"Add a New Tenant"];
    self.tenantTextField.text = @"";
    self.model.image = [Utils circleImageWithRadius:17.5f
                                        borderWidth:1.25f
                                        borderColor:RGB(125, 125, 125)
                                              image:IMG(@"will_add_suggestion")];
    [super setModel:self.model];
}

- (void)setModel:(RCSuggestionViewModel *)model
{
    [super setModel:model];
    [self setHidden:YES];
    [self setPlaceholedText:@"Add a New Tenant"];
}

- (void)setHidden:(BOOL)hidden {
    self.separator.hidden = hidden;
    self.okButton.hidden = hidden;
}

- (void)setPlaceholedText:(NSString *)placeholderText {
    NSAttributedString *attrPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText
                                                                          attributes:@{NSForegroundColorAttributeName : RGB(46, 49, 146),
                                                                                       NSFontAttributeName : self.tenantTextField.font}];
    self.tenantTextField.attributedPlaceholder = attrPlaceholder;
}

@end
