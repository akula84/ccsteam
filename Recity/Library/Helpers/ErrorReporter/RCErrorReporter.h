//
//  RCErrorReporter.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 14.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCErrorReporter : NSObject

+ (void)reportErrorIfNeeded:(NSError *)error fromViewController:(UIViewController *)presentingViewController;

@end
