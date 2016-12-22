//
//  RCOtherSuggestionViewController.m
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCOtherSuggestionViewController.h"

#import "RCSuggestionViewModel.h"

@interface RCOtherSuggestionViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textSuggestionView;

@end

@implementation RCOtherSuggestionViewController

- (void)setupUI
{
    [super setupUI];
    
    self.textSuggestionView.text = self.modelForSuggestion.text;
}

- (void)setupGesture
{
    [super setupGesture];
    
    UITapGestureRecognizer *tapScreen = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapScreen];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tapScreen {
    [self.textSuggestionView resignFirstResponder];
}

- (RCSuggestionViewModel *)modelForSuggestion
{
    return self.suggestionManager.suggestionViewModels[0];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.modelForSuggestion.text = textView.text;
    [self checkEnableSubmitButton];
}

@end
