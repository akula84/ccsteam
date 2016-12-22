//
//  AppState.h
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCUser.h"

@interface AppState : NSObject

@property (strong, nonatomic) RCUser *user;

+ (instancetype)sharedInstance;

- (BOOL)isFirstLaunch;

- (void)saveUserPasswordToKeychain:(NSString *)userPassword;
- (NSString *)savedUserPassword;
- (void)eraseKeychainedUserPassword;

@end
