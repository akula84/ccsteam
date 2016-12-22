//
//  RCTypeDetails+CoreDataProperties.h
//  Recity
//
//  Created by Vitaliy Zhukov on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCTypeDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTypeDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *apartments;
@property (nullable, nonatomic, retain) NSNumber *condominiums;
@property (nullable, nonatomic, retain) NSNumber *entertainment;
@property (nullable, nonatomic, retain) NSNumber *entertainmentSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedEntertainmentSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedHotelSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedNumberOfResidentialUnits;
@property (nullable, nonatomic, retain) NSNumber *estimatedOfficeSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedOtherTypeSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedResidentialSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedRetailSize;
@property (nullable, nonatomic, retain) NSNumber *hotel;
@property (nullable, nonatomic, retain) NSNumber *hotelSize;
@property (nullable, nonatomic, retain) NSNumber *numberOfHotelRooms;
@property (nullable, nonatomic, retain) NSNumber *numberOfParkingSpaces;
@property (nullable, nonatomic, retain) NSNumber *numberOfResidentialUnits;
@property (nullable, nonatomic, retain) NSNumber *numberOfSeats;
@property (nullable, nonatomic, retain) NSNumber *office;
@property (nullable, nonatomic, retain) NSNumber *officeSize;
@property (nullable, nonatomic, retain) NSNumber *otherType;
@property (nullable, nonatomic, retain) NSNumber *otherTypeSize;
@property (nullable, nonatomic, retain) NSNumber *residentialSize;
@property (nullable, nonatomic, retain) NSNumber *residentialTbd;
@property (nullable, nonatomic, retain) NSNumber *retail;
@property (nullable, nonatomic, retain) NSNumber *retailSize;
@property (nullable, nonatomic, retain) NSSet<RCProject *> *projects;

@end

@interface RCTypeDetails (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(RCProject *)value;
- (void)removeProjectsObject:(RCProject *)value;
- (void)addProjects:(NSSet<RCProject *> *)values;
- (void)removeProjects:(NSSet<RCProject *> *)values;

@end

NS_ASSUME_NONNULL_END
