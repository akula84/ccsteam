//
//  RCTileOverlay.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 21.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTileOverlay.h"
#import "RCTileOverlayCache.h"

@implementation RCTileOverlay
{
    NSManagedObjectContext *_context;
}

- (instancetype)initWithURLTemplate:(NSString *)URLTemplate {
    if (self = [super initWithURLTemplate:URLTemplate]) {
        _context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_rootSavingContext]];
    }
    
    return self;
}

- (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData * _Nullable, NSError * _Nullable))result {
    @weakify(self)
    [_context performBlock:^{
        @strongify(self)
        [self fetchTileAtPath:path result:result];
    }];
}

- (void)fetchTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData * _Nullable, NSError * _Nullable))result {
    __block NSData *cachedData;

    @try {
        cachedData = [self cachedDataForPath:path];
    } @catch (NSException *exception) {}
    
    if (cachedData != nil) {
        result(cachedData, nil);
        
        return;
    }
    @weakify(self)
    [super loadTileAtPath:path result:^(NSData *data, NSError *error) {
        @strongify(self)
        if (data != nil) {
            [self cacheData:data path:path];
        }
        result(data, error);
    }];
}

- (NSData *)cachedDataForPath:(MKTileOverlayPath)path {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(x == %@) && (y == %@) && (z == %@)", @(path.x), @(path.y), @(path.z)];
    RCTileOverlayCache *cache = [RCTileOverlayCache MR_findAllWithPredicate:predicate inContext:_context].firstObject;
    
    return cache.data;
}

- (void)cacheData:(NSData *)data path:(MKTileOverlayPath)path {
    [_context performBlock:^{
        [_context MR_setWorkingName:NSStringFromSelector(_cmd)];

        RCTileOverlayCache *newCacheInject = [RCTileOverlayCache MR_createEntityInContext:_context];
        
        newCacheInject.data = data;
        newCacheInject.x = @(path.x);
        newCacheInject.y = @(path.y);
        newCacheInject.z = @(path.z);
        
        [_context MR_saveWithOptions:MRSaveParentContexts completion:nil];
    }];
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        RCTileOverlayCache *newCacheInject = [RCTileOverlayCache MR_createEntityInContext:localContext];
//        
//        newCacheInject.data = data;
//        newCacheInject.x = @(path.x);
//        newCacheInject.y = @(path.y);
//        newCacheInject.z = @(path.z);
//    }];
}

@end
