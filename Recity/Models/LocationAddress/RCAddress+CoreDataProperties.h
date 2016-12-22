//
//  RCAddress+CoreDataProperties.h
//  Recity
//
//  Created by Artem Kulagin on 20.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCAddress (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *developmentIndex;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *overallInsightType;
@property (nullable, nonatomic, retain) NSNumber *permitsOneToTwoYears;
@property (nullable, nonatomic, retain) NSNumber *permitsTwoToThreeYears;
@property (nullable, nonatomic, retain) NSNumber *permitsZeroToOneYear;
@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *formattedAddress;
@property (nullable, nonatomic, retain) NSString *placeName;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *zipCode;

@property (nullable, nonatomic, retain) NSString *shareUrl;

@end

NS_ASSUME_NONNULL_END
