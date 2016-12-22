//
//  RCFavoritedProjectInfo.m
//  
//
//  Created by Matveev on 10/05/16.
//
//

#import "RCFavoritedProjectInfo.h"

@implementation RCFavoritedProjectInfo

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toProperty:@"uid"];
        [mapping mapKeyPath:@"projectId" toProperty:@"projectUID"];
        [mapping mapKeyPath:@"location.coordinate.latitude" toProperty:@"latitude"];
        [mapping mapKeyPath:@"location.coordinate.longitude" toProperty:@"longitude"];
        [mapping mapKeyPath:@"location.address" toProperty:@"address"];
        
        [mapping setPrimaryKey:@"uid"];
    }];
}

@end
