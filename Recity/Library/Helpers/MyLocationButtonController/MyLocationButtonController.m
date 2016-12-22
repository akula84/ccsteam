//
//  MyLocationButtonController.m
//  Recity
//
//  Created by Artem Kulagin on 01.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "MyLocationButtonController.h"

@implementation MyLocationButtonController
SINGLETON_OBJECT

+ (void)prepareActived:(BOOL)actived
{
    RUN_BLOCK([MyLocationButtonController  shared].prepareActived,actived);
}

@end
