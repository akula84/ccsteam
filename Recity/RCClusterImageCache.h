//
//  RCClusterImageCache.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 28.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCClusterImageCache : NSObject

+ (instancetype)shared;
- (UIImage *)imageForCount:(NSUInteger)count;

@end
