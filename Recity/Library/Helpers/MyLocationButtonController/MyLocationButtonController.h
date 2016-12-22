//
//  MyLocationButtonController.h
//  Recity
//
//  Created by Artem Kulagin on 01.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@interface MyLocationButtonController : NSObject

@property (copy, nonatomic) void(^prepareActived)(BOOL actived);

+ (void)prepareActived:(BOOL)actived;

@end
