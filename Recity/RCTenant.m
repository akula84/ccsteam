//
//  RCTenant.m
//  
//
//  Created by Matveev on 29/04/16.
//
//

#import "RCTenant.h"
#import "RCProject.h"

@implementation RCTenant

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:({
            @[
              @"name",
              @"type",
              ];
        })];
    }];
}
@end
