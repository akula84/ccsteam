//
//  RCBaseNavigationController.h
//  Recity
//
//  Created by Vitaliy Zhukov on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

#define direction_left kCATransitionFromLeft
#define direction_top kCATransitionFromBottom
#define direction_right kCATransitionFromRight
#define direction_bottom kCATransitionFromTop

@interface RCBaseNavigationController : UINavigationController

- (void)slideLayerInDirection:(NSString *)direction
                      andPush:(UIViewController *)dstVC;
- (void)slideAndPopLayerInDirection:(NSString *)direction;

- (void)slideLayerInDirection:(NSString *)direction
                       andPop:(UIViewController *)popVC;

@end
