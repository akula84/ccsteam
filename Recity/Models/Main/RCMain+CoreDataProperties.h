//
//  RCMain+CoreDataProperties.h
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMain+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RCMain (CoreDataProperties)

+ (NSFetchRequest<RCMain *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *temp;
@property (nullable, nonatomic, retain) RCMap *weater;

@end

NS_ASSUME_NONNULL_END
