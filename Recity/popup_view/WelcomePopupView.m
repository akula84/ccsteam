//
//  WelcomePopupView.m
//  Recity
//
//  Created by Matveev on 13/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "WelcomePopupView.h"
#import "RoundedButton.h"

@interface WelcomePopupView ()

@property (weak, nonatomic) IBOutlet RoundedButton *button;

@end

@implementation WelcomePopupView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.button setBorderColor:kDarkPurpleColor borderWidth:2 cornerRadius:_button.radius];
}

- (IBAction)gotitAction {
    RUN_BLOCK(self.gotitButtonPressedBlock);
}

@end
