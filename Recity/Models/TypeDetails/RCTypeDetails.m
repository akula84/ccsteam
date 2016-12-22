//
//  RCTypeDetails.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTypeDetails.h"

@implementation RCTypeDetails

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"apartments = %@\n",self.apartments];
    [string appendFormat:@"condominiums = %@\n",self.condominiums];
    [string appendFormat:@"residentialTbd = %@\n",self.residentialTbd];
    [string appendFormat:@"retail = %@\n",self.retail];
    [string appendFormat:@"office = %@\n",self.office];
    
    [string appendFormat:@"hotel = %@\n",self.hotel];
    [string appendFormat:@"entertainment = %@\n",self.entertainment];
    [string appendFormat:@"otherType = %@\n",self.otherType];
    [string appendFormat:@"numberOfResidentialUnits = %@\n",self.numberOfResidentialUnits];
    [string appendFormat:@"numberOfSeats = %@\n",self.numberOfSeats];
    
    [string appendFormat:@"retailSize = %@\n",self.retailSize];
    [string appendFormat:@"estimatedRetailSize = %@\n",self.estimatedRetailSize];
    [string appendFormat:@"officeSize = %@\n",self.officeSize];
    [string appendFormat:@"numberOfHotelRooms = %@\n",self.numberOfHotelRooms];
    [string appendFormat:@"numberOfParkingSpaces = %@\n",self.numberOfParkingSpaces];
    
    return string;
}

@end
