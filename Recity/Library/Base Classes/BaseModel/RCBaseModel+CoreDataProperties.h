//
//  RCBaseModel+CoreDataProperties.h
//  
//
//  Created by Vitaliy Zhukov on 06.06.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCBaseModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *uid;

@end

NS_ASSUME_NONNULL_END
