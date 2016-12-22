//
//  RCTypeDetails.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTypeDetails.h"

@implementation RCTypeDetails

+ (EKManagedObjectMapping *)objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:({
            @[
              @"apartments",
              @"condominiums",
              @"residentialTbd",
              @"retail",
              @"office",
              @"hotel",
              @"entertainment",
              @"otherType",
              @"numberOfResidentialUnits",
              @"estimatedNumberOfResidentialUnits",
              @"numberOfSeats",
              @"retailSize",
              @"estimatedRetailSize",
              @"officeSize",
              @"numberOfHotelRooms",
              @"numberOfParkingSpaces",
              ];
        })];
    }];
}

@end
