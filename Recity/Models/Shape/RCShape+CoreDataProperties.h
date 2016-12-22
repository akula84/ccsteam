//
//  RCShape+CoreDataProperties.h
//  
//
//  Created by Matveev on 24/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCShape (CoreDataProperties)

@property (nullable, nonatomic, retain) NSOrderedSet<RCPoint *> *shapePoints;
@property (nullable, nonatomic, retain) NSSet<RCProject *> *shapeProjects;

@end

@interface RCShape (CoreDataGeneratedAccessors)

- (void)insertObject:(RCPoint *)value inShapePointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromShapePointsAtIndex:(NSUInteger)idx;
- (void)insertShapePoints:(NSArray<RCPoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeShapePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInShapePointsAtIndex:(NSUInteger)idx withObject:(RCPoint *)value;
- (void)replaceShapePointsAtIndexes:(NSIndexSet *)indexes withShapePoints:(NSArray<RCPoint *> *)values;
- (void)addShapePointsObject:(RCPoint *)value;
- (void)removeShapePointsObject:(RCPoint *)value;
- (void)addShapePoints:(NSOrderedSet<RCPoint *> *)values;
- (void)removeShapePoints:(NSOrderedSet<RCPoint *> *)values;

- (void)addShapeProjectsObject:(RCProject *)value;
- (void)removeShapeProjectsObject:(RCProject *)value;
- (void)addShapeProjects:(NSSet<RCProject *> *)values;
- (void)removeShapeProjects:(NSSet<RCProject *> *)values;

@end

NS_ASSUME_NONNULL_END
