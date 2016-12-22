//
//  RCPoint.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPoint.h"

@implementation RCPoint

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"latitude", @"longitude"]];
    }];
}

@end
