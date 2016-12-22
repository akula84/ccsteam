//
//  RCProject+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCProject.h"
#import "RCTenant.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCProject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSData *architectsData;
@property (nullable, nonatomic, retain) NSNumber *buildingSize;
@property (nullable, nonatomic, retain) NSString *completionDate;
@property (nullable, nonatomic, retain) NSString *completionTime;
@property (nullable, nonatomic, retain) NSString *constructionType;
@property (nullable, nonatomic, retain) NSData *developersData;
@property (nullable, nonatomic, retain) NSNumber *developmentIndex;
@property (nullable, nonatomic, retain) NSNumber *estimatedBuildingSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedFloorCount;
@property (nullable, nonatomic, retain) NSNumber *floorCount;
@property (nullable, nonatomic, retain) NSNumber *landSize;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) RCPoint *centerPoint;
@property (nullable, nonatomic, retain) NSSet<RCImage *> *images;
@property (nullable, nonatomic, retain) RCImage *previewImage;
@property (nullable, nonatomic, retain) NSSet<RCUser *> *recenterUsers;
@property (nullable, nonatomic, retain) NSSet<RCShape *> *shapes;
@property (nullable, nonatomic, retain) NSSet<RCTenant *> *tenants;
@property (nullable, nonatomic, retain) RCTypeDetails *typeDetails;

@end

@interface RCProject (CoreDataGeneratedAccessors)

- (void)addImagesObject:(RCImage *)value;
- (void)removeImagesObject:(RCImage *)value;
- (void)addImages:(NSSet<RCImage *> *)values;
- (void)removeImages:(NSSet<RCImage *> *)values;

- (void)addRecenterUsersObject:(RCUser *)value;
- (void)removeRecenterUsersObject:(RCUser *)value;
- (void)addRecenterUsers:(NSSet<RCUser *> *)values;
- (void)removeRecenterUsers:(NSSet<RCUser *> *)values;

- (void)addShapesObject:(RCShape *)value;
- (void)removeShapesObject:(RCShape *)value;
- (void)addShapes:(NSSet<RCShape *> *)values;
- (void)removeShapes:(NSSet<RCShape *> *)values;

- (void)addTenantsObject:(RCTenant *)value;
- (void)removeTenantsObject:(RCTenant *)value;
- (void)addTenants:(NSSet<RCTenant *> *)values;
- (void)removeTenants:(NSSet<RCTenant *> *)values;

@end

NS_ASSUME_NONNULL_END
