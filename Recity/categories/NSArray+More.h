//
//  NSArray+More.h
//  golf-fitness
//
//  Created by Matveev on 04.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (More)

- (NSArray *)filteredByIntegerUID:(NSNumber *)uid;
- (NSArray *)filteredByStringUID:(NSString *)uid;

@end
