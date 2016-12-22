//
//  AppDelegate.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "AppDelegate.h"

#import "RCLoginViewController.h"
#import "KeyboardInfo.h"
#import "RCHTTPSessionManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) RCLoginViewController *loginVC;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return [UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MagicalRecord setupCoreDataStack];
    [RCHTTPSessionManager shared];
    
    self.loginVC  = [RCLoginViewController instantiateFromStoryboardNamed:@"Main"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    nc.navigationBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window setRootViewController:nc];
    [[KeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
