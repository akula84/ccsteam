//
//  RCDragDetectorController.m
//  Recity
//
//  Created by Artem Kulagin on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDragDetectorController.h"

@implementation RCDragDetectorController
SINGLETON_OBJECT

+ (void)addNoProccessView:(UIView *)view
{
    RUN_BLOCK([self controller].didAddNoProccessView,view);
}

+ (RCDragDetectorController *)controller
{
    return [RCDragDetectorController shared];
}

@end
