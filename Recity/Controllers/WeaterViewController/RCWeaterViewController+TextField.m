//
//  RCWeaterViewController+TextField.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeaterViewController_Private.h"

@implementation RCWeaterViewController (TextField)

- (IBAction)textFieldChanged:(id)sender{
    [self sendToServer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyBoard];
    return true;
}

- (NSString *)text{
    return self.textField.text;
}

@end
