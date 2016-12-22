//
//  RCTenant+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCTenant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTenant (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSSet<RCProject *> *projects;

@end

@interface RCTenant (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(RCProject *)value;
- (void)removeProjectsObject:(RCProject *)value;
- (void)addProjects:(NSSet<RCProject *> *)values;
- (void)removeProjects:(NSSet<RCProject *> *)values;

@end

NS_ASSUME_NONNULL_END
