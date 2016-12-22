//
//  LoginViewController.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCLoginViewController.h"
#import "ValidationInformerTextField.h"
#import "EmailValidationStrategy.h"
#import "PasswordValidationStrategy.h"
#import "RCUser.h"
#import "WelcomePopupView.h"
#import "ScrollViewComfortTextInput.h"
#import "AppState.h"
#import "RCErrorReporter.h"
#import "AboutPopupView.h"

@interface RCLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailValidationLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordValidationLabel;
@property (weak, nonatomic) IBOutlet ValidationInformerTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ValidationInformerTextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *emailSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@property (strong, nonatomic) AboutPopupView *popupView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) ScrollViewComfortTextInput *comfortTextInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *appIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *globalErrorLabel;

@end

@implementation RCLoginViewController

- (void)viewDidLoad {
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

    if ([AppState sharedInstance].isFirstLaunch) {
        [self.popupView displayOnView:self.view];
    }
    [self configureTextFieldsValidation];
    
    RCUser *firstUser = [[RCUser MR_findAll] firstObject];
    if (firstUser.authorizationToken.length > 0) {
        [AppState sharedInstance].user = firstUser;
        [self performSegueWithIdentifier:[UINavigationController rc_className] sender:nil];
    }
    
    //      simulate bad token
//    [self simulateBadToken];
}

- (void)simulateBadToken {
    if (IS_DEBUG_BUILD) {
        RCUser *firstUser = [[RCUser MR_findAll] firstObject];
        if (firstUser) {
            NSLog(@"SAVED PASSWORD %@",[[AppState sharedInstance] savedUserPassword]);
            NSLog(@"first user token BEFORE %@",firstUser.authorizationToken);
            [firstUser DEBUG_simulateBadTokenCompletion:^{
                NSArray *users = [RCUser rc_objectsWithValues:@[firstUser.login] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]];
                if (users.count > 0) {
                    RCUser *user = [users firstObject];
                    NSLog(@"first user token AFTER %@",user.authorizationToken);
                    [AppState sharedInstance].user = user;
                    [self performSegueWithIdentifier:[UINavigationController rc_className] sender:nil];
                }
            }];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureTextFieldsForConvinientUsing];
    
//    [self performSegueWithIdentifier:[UINavigationController rc_className] sender:nil];
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
        [RCUser authWithLogin:self.emailTextField.text password:self.passwordTextField.text].then(^(RCUser *user){
//            RCUser *newUser = [[RCUser rc_objectsWithValues:@[@"manager@recity.co"] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
//            NSLog(@"newUser %@",newUser);
            if (user.authorizationToken.length == 0) {
                return;
            }
            [AppState sharedInstance].user = user;
            [[AppState sharedInstance] saveUserPasswordToKeychain:self.passwordTextField.text];
            
            void (^goToMap)() = ^{
                [self performSegueWithIdentifier:[UINavigationController rc_className] sender:nil];
            };
            if (self.presentedViewController) {
                [self.presentedViewController dismissViewControllerAnimated:YES completion:goToMap];
            } else {
                goToMap();
            }
        }).catch(^(NSError *error){
            self.loginButton.enabled = YES;
            if (error.code == 401) {
                [self displayCredentialsError];
            } else if (error.code == 500) {
                [self displayServerFailedError];
            } else {
                [RCErrorReporter reportErrorIfNeeded:error fromViewController:self];
            }
        }).finally(^(){
            self.loginButton.enabled = YES;
        });
    }
}

- (void)displayCredentialsError {
    [self displayErrorInHeader:LOC(@"INVALID EMAIL OR PASSWORD.\nPLEASE RE-ENTER.")];
}

- (void)displayServerFailedError {
    [self displayErrorInHeader:LOC(@"Server is busy. Please retry in couple hours.")];
}

- (void)displayErrorInHeader:(NSString *)errorString {
    self.globalErrorLabel.text = errorString;
    [self.emailTextField turnIntoValidState];
    [self.passwordTextField turnIntoValidState];
}

- (IBAction)newtoRecityAction {
    [self.view endEditing:YES];
    
    [self.popupView displayOnView:self.view];
}

- (PopupView *)popupView {
    if (_popupView) {
        return _popupView;
    }
    
    _popupView = [[[NSBundle mainBundle] loadNibNamed:@"AboutPopupView" owner:nil options:nil] firstObject];
    _popupView.headerLabel.text = @"New to Recity?";
    
//    __weak typeof(_popupView) wPopupView = _popupView;
//    _popupView.gotitButtonPressedBlock = ^() {
//        [wPopupView hideAnimated];
//    };
    return _popupView;
}

- (ScrollViewComfortTextInput *)configureTextFieldsForConvinientUsing {
    if (_comfortTextInput) {
        return _comfortTextInput;
    }
    
    _comfortTextInput = [[ScrollViewComfortTextInput alloc] initWithOrderedTextInputControls:@[self.emailTextField,self.passwordTextField] withOwnerView:self.view withScrollViewInsideOwnerViewWhereTextFieldsLocated:self.scrollView];
    @weakify(self);
    _comfortTextInput.lastTextInputControlDidEndEditingBlock = ^(UIView *textInputControl) {
        @strongify(self);
        [self loginAction];
    };
    return _comfortTextInput;
}

@end
