//
//  RCMapViewController+DevelopmentIndex.m
//  Recity
//
//  Created by Vitaliy Zhukov on 20.06.16.
//  Copyright © 2016 Recity. All rights reserved.
///var/folders/2y/479yl_4d75jg7_4r3zm59sx00000gn/T/com.monosnap.monosnap/RCMapViewController+DevelopmentIndex.m 2016-07-04 16-46-07.jpg

#import "RCMapViewController_Private.h"

#import "RCAddress.h"
#import "RCAddressPageController.h"

@implementation RCMapViewController (DevelopmentIndex)

- (void)addAddressToHistory:(RCAddress *)address
{
    [self showObjectInHistory:address];
}

- (RCAddressPageController *)developmentIndexViewControllerForAddress:(RCAddress *)address
{
    RCAddressPageController *diController = [RCAddressPageController instantiateFromStoryboardNamed:@"AddressPageController"];
    diController.address = address;
    
    return (RCAddressPageController *)diController;
}

- (NSUInteger)indexInHistoryOfAddress:(RCAddress *)address
{
    for (UIViewController *vc in self.detailsHistory) {
        if ([vc isKindOfClass:[RCAddressPageController class]]) {
            RCAddressPageController *controller = (RCAddressPageController *)vc;
            if ([controller.address.latitude isEqualToNumber:address.latitude] && [controller.address.longitude isEqualToNumber:address.longitude]) {
                return [self.detailsHistory indexOfObject:vc];
            }
        }
    }
    
    return NSNotFound;
}

@end
