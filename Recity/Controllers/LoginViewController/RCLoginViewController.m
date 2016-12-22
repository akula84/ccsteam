//
//  LoginViewController.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCLoginViewController.h"
#import "RCLoginViewController_Private.h"

#import "EmailValidationStrategy.h"
#import "PasswordValidationStrategy.h"
#import "AboutPopupView.h"
#import "ValidationInformerTextField.h"
#import "LoaderView.h"

@interface RCLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailValidationLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordValidationLabel;
@property (weak, nonatomic) IBOutlet UIView *emailSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *globalErrorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (strong, nonatomic) AboutPopupView *popupView;
@property (strong, nonatomic) LoaderView *loaderView;

@end

@implementation RCLoginViewController

- (void)checkToken
{
    if ([AppState isHaveToken]) {
        [self addLoadingView];
        [self goToMap];
    }
}

- (void)addLoadingView
{
    LoaderView *loaderView = [[LoaderView alloc]initWithFrame:self.view.bounds];
    [loaderView prepareLogin];
    loaderView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        loaderView.alpha = 1.0f;
    } completion:nil];
    [self.view addSubview: loaderView];
    self.loaderView = loaderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTextFieldsValidation];
    
    if (IS_DEBUG_BUILD) {
        self.emailTextField.text = @"basic@recity.co";
        self.passwordTextField.text = @"123";
    }
    
    UIImage* sourceImage = self.appIconImageView.image;
    UIImage* flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                                scale:sourceImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    self.appIconImageView.image = flippedImage;

    [self configureTextFieldsValidation];
}

- (void)goToMap
{
    UINavigationController *nav = [UINavigationController instantiateFromStoryboardNamed:@"Map"];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        [self.loaderView removeFromSuperview];
    }];
}

- (void)configureTextFieldsValidation {
    self.emailTextField.validationStrategy = [[EmailValidationStrategy alloc] initWithMinLength:nil maxLength:nil];
    self.emailTextField.validateOnFly = NO;
    self.emailTextField.informationLabel = self.emailValidationLabel;
    self.emailTextField.separatorView = self.emailSeparator;
    
    self.passwordTextField.validationStrategy = [[PasswordValidationStrategy alloc] initWithMinLength:@(1) maxLength:nil];
    self.passwordTextField.validateOnFly = NO;
    self.passwordTextField.informationLabel = self.passwordValidationLabel;
    self.passwordTextField.separatorView = self.passwordSeparator;
}

- (IBAction)forgotAction {
    
}

- (IBAction)loginAction {
    BOOL bothTextsInvalid = ![self.emailTextField currentTextIsValid] && ![self.passwordTextField currentTextIsValid];
    if (bothTextsInvalid) {
        [self displayCredentialsError];
    } else {
        self.globalErrorLabel.text = @" ";
        [self.emailTextField validateAndRunDidChangedTextValidationFinishedBlock];
        [self.passwordTextField validateAndRunDidChangedTextValidationFinishedBlock];
    }
    
    BOOL bothTextsCorrect = [self.emailTextField currentTextIsValid] && [self.passwordTextField currentTextIsValid];
    if (bothTextsCorrect) {
        self.globalErrorLabel.text = @" ";
        self.loginButton.enabled = NO;
        [self authorization];
    }
}

- (void)displayCredentialsError
{
    [self displayErrorInHeader:LOC(@"INVALID EMAIL OR PASSWORD.\nPLEASE RE-ENTER.")];
}

- (void)displayServerFailedError
{
    [self displayErrorInHeader:LOC(@"Server is busy. Please retry in couple hours.")];
}

- (void)displayErrorInHeader:(NSString *)errorString {
    self.globalErrorLabel.text = errorString;
    [self.emailTextField turnIntoValidState];
    [self.passwordTextField turnIntoValidState];
}

- (IBAction)newtoRecityAction {
    [self.view endEditing:YES];
    
    [self showPopupView];
}

- (void)showPopupView
{
   [self.popupView displayOnView:self.view];
}

- (PopupView *)popupView
{
    if (!_popupView) {
        AboutPopupView *popupView = [AboutPopupView loadNib];
        [popupView setupHeaderText:@"New to Recity?"
                          mainText:@"The Recity mobile app is a tool for our subscribers. If you already use Recity, just sign in with your email and password."
                      okButtonText:@"Got it"];
        _popupView = popupView;
    }
    return _popupView;
}

@end
