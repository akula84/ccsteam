//
//  RCUserNotes+CoreDataProperties.h
//  
//
//  Created by ezaji.dm on 15.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCUserNotes.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUserNotes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *projectUID;
@property (nullable, nonatomic, retain) NSDate *lastModifiedAt;
@property (nullable, nonatomic, retain) NSString *textNotes;
@property (nullable, nonatomic, retain) RCUserInfo *userinfo;

@end

NS_ASSUME_NONNULL_END
