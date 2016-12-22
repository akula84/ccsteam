//
//  AppDelegate.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "AppDelegate.h"
#import "RCRouter.h"

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self magicalRecordSetup];
    [self globalSetup];
    [RCRouter showWeater];
    return YES;
}

- (void)globalSetup{
    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleBlueBar]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

- (void)magicalRecordSetup{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible{
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

@end
