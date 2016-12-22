//
//  SharePopupView.m
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "SharePopupView.h"

#import "RoundedButton.h"

@interface SharePopupView ()

@property (weak, nonatomic) IBOutlet RoundedButton *button;

@end

@implementation SharePopupView

- (IBAction)closeAction
{
    [self hideAnimated];
    RUN_BLOCK(self.didCloseAction);
}

- (IBAction)copyLinkAction {
    if(self.linkLabel.text.length > 0) {
        [[UIPasteboard generalPasteboard] setString:self.linkLabel.text];
    }
}

- (IBAction)tapLinkAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkLabel.text]];
}

@end
