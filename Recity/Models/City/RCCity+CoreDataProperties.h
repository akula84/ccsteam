//
//  RCCity+CoreDataProperties.h
//  
//
//  Created by Matveev on 25/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCCity.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCCity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSString *cityName;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *cityNameWithState;

@end

NS_ASSUME_NONNULL_END
