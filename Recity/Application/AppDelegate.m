//
//  AppDelegate.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "AppDelegate.h"

#import "RCLoginViewController.h"
#import "RCSearchManager.h"
/*
#import "RCKeyBoardManager.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
*/

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [MagicalRecord setupAutoMigratingCoreDataStack];
    /*
    [RCKeyBoardManager shared];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    */
    UIViewController *vc  = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    vc.view = view;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window setRootViewController:nc];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)medicalOffLog
{
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
}
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible
{
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

@end
