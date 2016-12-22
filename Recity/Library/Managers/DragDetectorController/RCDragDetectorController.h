//
//  RCDragDetectorController.h
//  Recity
//
//  Created by Artem Kulagin on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "NSObject+SingletonObject.h"

@interface RCDragDetectorController : NSObject

@property (copy, nonatomic) void(^didAddNoProccessView)(UIView *view);

+ (void)addNoProccessView:(UIView *)view;

@end
