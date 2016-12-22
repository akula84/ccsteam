//
//  RCProjectSuggestionViewController.m
//  Recity
//
//  Created by ezaji.dm on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestionViewController.h"

#import "RCThankSuggestionViewController.h"

#import "RCSuggestionAPI.h"
#import "RCErrorReporter.h"

@interface RCProjectSuggestionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RCProjectSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkEnableSubmitButton];
}

- (void)checkEnableSubmitButton {
    self.submitButton.enabled = [self.suggestionManager isSubmitSuggestion];
}

- (IBAction)submitAction {
    self.submitButton.enabled = NO;
    
    [RCSuggestionAPI withObject:[self.suggestionManager.suggestion parametersOfSuggestion]
                     completion:^(id reply, NSError *error, BOOL *handleError)
    {
        if (error) {
            [RCErrorReporter reportErrorIfNeeded:error
                              fromViewController:self];
        } else {
            RCThankSuggestionViewController *thankSuggestionVC = [[RCThankSuggestionViewController alloc] initWithNibName:@"RCThankSuggestionView"
                                                                                                                   bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:thankSuggestionVC
                                                 animated:YES];
        }
        self.submitButton.enabled = YES;
    }];
}

@end
