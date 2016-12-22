//
//  AppDelegate.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 RC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end

