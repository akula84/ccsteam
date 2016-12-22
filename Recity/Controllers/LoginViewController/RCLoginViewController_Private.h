//
//  RCLoginViewController+SignIn.h
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCLoginViewController.h"

@class ValidationInformerTextField;

@interface RCLoginViewController()

@property (weak, nonatomic) IBOutlet ValidationInformerTextField *emailTextField;
@property (weak, nonatomic) IBOutlet ValidationInformerTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (void)displayCredentialsError;
- (void)displayServerFailedError;
- (void)goToMap;

@end

@interface RCLoginViewController (SignIn)

- (void)authorization;

@end
