//
//  RCTileOverlayCache+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCTileOverlayCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCTileOverlayCache (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSNumber *x;
@property (nullable, nonatomic, retain) NSNumber *y;
@property (nullable, nonatomic, retain) NSNumber *z;

@end

NS_ASSUME_NONNULL_END
