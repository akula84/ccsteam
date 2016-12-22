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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.button setBorderColor:kDarkPurpleColor borderWidth:2 cornerRadius:_button.radius];
}

- (IBAction)copyLinkAction {
    [[UIPasteboard generalPasteboard] setString:self.linkLabel.text];
}

@end
