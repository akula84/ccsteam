//
//  RCTileOverlay.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 21.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTileOverlay.h"

#import "RCTileOverlayCache.h"

@interface RCTileOverlay()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation RCTileOverlay

- (instancetype)initWithURLTemplate:(NSString *)URLTemplate
{
    if (self = [super initWithURLTemplate:URLTemplate]) {
        _context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_rootSavingContext]];
    }
    
    return self;
}

- (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData * _Nullable, NSError * _Nullable))result
{
    [self fetchTileAtPath:path result:result];
}

- (void)fetchTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData * _Nullable, NSError * _Nullable))result
{
    NSData *cachedData = [self cachedDataForPath:path];
    
    if (cachedData) {
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

- (NSData *)cachedDataForPath:(MKTileOverlayPath)path
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(x == %@) and (y == %@) and (z == %@)", @(path.x), @(path.y), @(path.z)];
    RCTileOverlayCache *cache = [RCTileOverlayCache MR_findFirstWithPredicate:predicate inContext:self.context];
    return cache.data;
}

- (void)cacheData:(NSData *)data path:(MKTileOverlayPath)path
{
    [self.context performBlockAndWait:^{
        
        RCTileOverlayCache *newCacheInject = [RCTileOverlayCache MR_createEntityInContext:self.context];
        newCacheInject.data = data;
        newCacheInject.x = @(path.x);
        newCacheInject.y = @(path.y);
        newCacheInject.z = @(path.z);
        
        [self.context MR_saveOnlySelfAndWait];
    }];
}

@end
