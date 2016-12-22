//
//  RCWeaterViewController_private.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "RCWeaterViewController.h"

@interface RCWeaterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

/**
 *  send to Server http://api.openweathermap.org with parameters
 */
- (void)sendToServer;

@end

@interface RCWeaterViewController (TextField) <UITextFieldDelegate>

- (IBAction)textFieldChanged:(id)sender;
/**
 *  @return text textField.text
 */
- (NSString *)text;

@end

@interface RCWeaterViewController (Tap)

/**
 *  add UITapGestureRecognizer to view from hide keyboard if need
 */
- (void)addTap;

@end

@interface RCWeaterViewController (UI)

- (void)hideKeyBoard;
/**
 *  prepare visible load data weather
 */
- (void)prepareMap:(id)object;

@end
