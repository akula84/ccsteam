//
//  AppState.h
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"
#import "RCMapSettings.h"

@class RCCity;

@interface AppState : NSObject

@property (strong, nonatomic) RCUser *user;

@property (assign, nonatomic) BOOL firstProjectsDownloadingFinished;

+ (instancetype)sharedInstance;

- (BOOL)isFirstLaunch;

+ (void)saveUserLogin:(NSString *)userLogin passwordToKeychain:(NSString *)userPassword;
+ (NSString *)savedUserLogin;
+ (NSString *)savedUserPassword;
- (RCCity *)currentCity;

+ (BOOL)advancedVersion;

+ (BOOL)isHaveToken;
+ (void)logOut:(void(^)(void))complete;

+ (void)saveMapSettings:(RCMapSettings *)mapSettings;
+ (RCMapSettings *)loadMapSettings;

@end
