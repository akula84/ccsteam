//
//  RCLoginViewController+SignIn.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCLoginViewController_Private.h"

#import "RCSignInAPI.h"
#import "ValidationInformerTextField.h"
#import "RCErrorReporter.h"
#import "AFURLResponseSerialization.h"

@implementation RCLoginViewController (SignIn)

- (void)authorization
{
    NSDictionary *object =  @{kLogin : self.emailTextField.text,
                              kPassword : self.passwordTextField.text,
                              kGrant_type : @"password"};
   [RCSignInAPI withObject:object completion:^(id reply, NSError *error, BOOL *handleError) {
       if (error) {
            [self showError:error];
        } else {
            [self showMap];
        }
        self.loginButton.enabled = YES;
    }];
}

- (void)showError:(NSError *)error
{
    NSInteger statusCode = [error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    if ((error.code == 401)||(statusCode == 400)) {
        [self displayCredentialsError];
    } else if (error.code == 500) {
        [self displayServerFailedError];
    } else {
        [RCErrorReporter reportErrorIfNeeded:error fromViewController:self];
    }
}

- (void)showMap
{
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self goToMap];
        }];
    } else {
        [self goToMap];
    }
}

@end
