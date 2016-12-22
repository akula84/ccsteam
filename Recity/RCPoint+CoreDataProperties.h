//
//  RCPoint+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCPoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) RCProject *project;
@property (nullable, nonatomic, retain) NSSet<RCShape *> *shapes;

@end

@interface RCPoint (CoreDataGeneratedAccessors)

- (void)addShapesObject:(RCShape *)value;
- (void)removeShapesObject:(RCShape *)value;
- (void)addShapes:(NSSet<RCShape *> *)values;
- (void)removeShapes:(NSSet<RCShape *> *)values;

@end

NS_ASSUME_NONNULL_END
