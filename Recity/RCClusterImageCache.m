//
//  RCClusterImageCache.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 28.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCClusterImageCache.h"
#import "RCClusterView.h"


static RCClusterImageCache * kSharedInstance = nil;

@interface RCClusterImageCache ()

@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) RCClusterView *clusterView;

@end


@implementation RCClusterImageCache

#pragma mark - LifeCycle

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSharedInstance = [[super allocWithZone:NULL]init];
        kSharedInstance.clusterView = [RCClusterView new];
    });
    
    return kSharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [self shared];
}

- (instancetype)init {
    if (kSharedInstance != nil) {
        
        return kSharedInstance;
    }
    return [super init];
}

#pragma mark - 

- (NSMutableDictionary *)dictionary {
    @synchronized (self) {
        if (_dictionary == nil) {
            _dictionary = [NSMutableDictionary dictionary];
        }
    }
    return _dictionary;
}

- (UIImage *)imageForCount:(NSUInteger)count {
    @synchronized (self) {
        UIImage *cachedImage = self.dictionary[@(count)];
        if (cachedImage) {
            return cachedImage;
        }
        [self.clusterView setCount:count];
        cachedImage = [self.clusterView snapshot];
        self.dictionary[@(count)] = cachedImage;
        
        return cachedImage;
    }
}


@end
