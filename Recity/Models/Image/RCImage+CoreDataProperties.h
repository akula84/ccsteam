//
//  RCImage+CoreDataProperties.h
//  
//
//  Created by Matveev on 24/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSSet<RCProject *> *imageProjects;
@property (nullable, nonatomic, retain) NSSet<RCProject *> *previewImageProjects;

@end

@interface RCImage (CoreDataGeneratedAccessors)

- (void)addImageProjectsObject:(RCProject *)value;
- (void)removeImageProjectsObject:(RCProject *)value;
- (void)addImageProjects:(NSSet<RCProject *> *)values;
- (void)removeImageProjects:(NSSet<RCProject *> *)values;

- (void)addPreviewImageProjectsObject:(RCProject *)value;
- (void)removePreviewImageProjectsObject:(RCProject *)value;
- (void)addPreviewImageProjects:(NSSet<RCProject *> *)values;
- (void)removePreviewImageProjects:(NSSet<RCProject *> *)values;

@end

NS_ASSUME_NONNULL_END
