//
//  RCUser+Recent.m
//  Recity
//
//  Created by Artem Kulagin on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"

#import "RCAddress.h"

@implementation RCUser (Recent)

- (void)addRecentItem:(RCBaseModel *)item completion:(dispatch_block_t)completion
{
    RCBaseModel *findedItem;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(RCBaseModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        BOOL result = NO;
        BOOL isEvalProject = evaluatedObject.uid.integerValue > 0;
        BOOL isEvalAddress = [evaluatedObject isKindOfClass:[RCAddress class]] && [item isKindOfClass:[RCAddress class]];
        
        if (isEvalProject) {
            result = [item.uid isEqualToNumber:evaluatedObject.uid];
        } else if (isEvalAddress) {
            RCAddress *address = (RCAddress *)item;
            RCAddress *evaluatedAddress = (RCAddress *)evaluatedObject;
            
            result = ([address.latitude isEqualToNumber:evaluatedAddress.latitude] &&
                      [address.longitude isEqualToNumber:evaluatedAddress.longitude] &&
                      [address.address isEqualToString:evaluatedAddress.address]);
        }
        return result;
    }];
    
    findedItem = [[self.recent filteredOrderedSetUsingPredicate:predicate] firstObject];

    [self removeRecentObject:findedItem];
    
    if (self.recent.count > 9) {
        [self removeObjectFromRecentItemAtIndex:0];
    }
    [self addRecentItemObject:item];
    
    RUN_BLOCK(completion);
}

- (void)addRecentItemObject:(id)value
{
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.recent];
    [newSet addObject:value];
    self.recent = newSet;
}

- (void)removeRecentObject:(RCBaseModel *)value
{
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.recent];
    [newSet removeObject:value];
    self.recent = newSet;
}

- (void)removeObjectFromRecentItemAtIndex:(NSUInteger)idx
{
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.recent];
    [newSet removeObjectAtIndex:idx];
    self.recent = newSet;
}

@end
