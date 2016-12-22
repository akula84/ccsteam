//
//  NSArray+More.m
//  golf-fitness
//
//  Created by Matveev on 04.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "NSArray+More.h"

@implementation NSArray (More)

- (NSArray *)filteredByIntegerUID:(NSNumber *)uid {
    NSArray *result = [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uid == %@",uid]];
    return result;
}

- (NSArray *)filteredByStringUID:(NSString *)uid {
    NSArray *result = [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uid = %@",uid]];
    return result;
}

@end
