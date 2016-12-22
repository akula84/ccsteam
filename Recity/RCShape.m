//
//  RCShape.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCShape.h"
#import "RCPoint.h"

@implementation RCShape

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping hasMany:[RCPoint class] forKeyPath:@"points" forProperty:@"shapePoints"];
    }];
}

@end
