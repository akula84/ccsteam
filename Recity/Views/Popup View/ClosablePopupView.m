//
//  ClosablePopupView.m
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "ClosablePopupView.h"

#import "UIFont+RecityFont.h"

@interface ClosablePopupView ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ClosablePopupView

- (IBAction)closeAction
{
    [self hideAnimated];
}

- (void)setupHeaderText:(NSString *)headerText
               mainText:(NSString *)mainText
           okButtonText:(NSString *)okButtonText
{
    self.headerLabel.text = headerText;
    self.aboutTextView.text = mainText;
    self.aboutTextView.textColor = RGB(125, 125, 125);
    self.aboutTextView.font = [UIFont flamaBook:17.f];
    [self.okButton setTitle:okButtonText
                   forState:UIControlStateNormal];
}

@end
