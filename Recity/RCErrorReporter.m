//
//  RCErrorReporter.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 14.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCErrorReporter.h"

@implementation RCErrorReporter

+ (void)reportErrorIfNeeded:(NSError *)error fromViewController:(UIViewController *)presentingViewController {
    NSString *errorMessage = nil;
    if (error.code >= NSURLErrorAppTransportSecurityRequiresSecureConnection &&
        error.code <= NSURLErrorBadURL) {
        errorMessage = @"Can't connect to the server. Please check network connection.";
    }
    
    if (errorMessage.length > 0) {
        UIAlertController *alertController;
        alertController = [UIAlertController alertControllerWithTitle:nil message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:({
            [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        })];
        [presentingViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
