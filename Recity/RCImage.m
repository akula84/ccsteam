//
//  RCImage.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCImage.h"

@implementation RCImage

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:({
            @[
              @"url",
              @"width",
              @"height",
              ];
        })];
    }];
}

@end
