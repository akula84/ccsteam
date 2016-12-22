//
//  RCProject+CoreDataProperties.h
//  Recity
//
//  Created by Artem Kulagin on 13.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCProject.h"

NS_ASSUME_NONNULL_BEGIN

@class RCTenant,RCShape,RCImage;

@interface RCProject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSData *architectsData;
@property (nullable, nonatomic, retain) NSNumber *buildingSize;
@property (nullable, nonatomic, retain) NSNumber *cityUID;
@property (nullable, nonatomic, retain) NSString *completionDate;
@property (nullable, nonatomic, retain) NSString *completionTime;
@property (nullable, nonatomic, retain) NSString *constructionType;
@property (nullable, nonatomic, retain) NSData *developersData;
@property (nullable, nonatomic, retain) NSNumber *developmentIndex;
@property (nullable, nonatomic, retain) NSNumber *estimatedBuildingSize;
@property (nullable, nonatomic, retain) NSNumber *estimatedFloorCount;
@property (nullable, nonatomic, retain) NSNumber *floorCount;
@property (nullable, nonatomic, retain) NSString *groundBreakingDate;
@property (nullable, nonatomic, retain) NSString *groundBreakingTime;
@property (nullable, nonatomic, retain) NSNumber *landSize;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) RCPoint *centerPoint;
@property (nullable, nonatomic, retain) NSOrderedSet<RCImage *> *images;
@property (nullable, nonatomic, retain) RCImage *previewImage;
@property (nullable, nonatomic, retain) NSSet<RCShape *> *shapes;
@property (nullable, nonatomic, retain) NSSet<RCTenant *> *tenants;
@property (nullable, nonatomic, retain) RCTypeDetails *typeDetails;

@end

@interface RCProject (CoreDataGeneratedAccessors)

- (void)insertObject:(RCImage *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray<RCImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(RCImage *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray<RCImage *> *)values;
- (void)addImagesObject:(RCImage *)value;
- (void)removeImagesObject:(RCImage *)value;
- (void)addImages:(NSOrderedSet<RCImage *> *)values;
- (void)removeImages:(NSOrderedSet<RCImage *> *)values;

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
