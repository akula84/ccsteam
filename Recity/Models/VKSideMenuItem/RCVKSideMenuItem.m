//
//  RCVKSideMenuItem.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCVKSideMenuItem.h"

@implementation RCVKSideMenuItem

+ (instancetype)itemImageName:(NSString *)imageName title:(NSString *)title
{
    RCVKSideMenuItem *item = [RCVKSideMenuItem new];
    item.imageName = imageName;
    item.title = title;
    return item;
}

@end
