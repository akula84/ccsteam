//
//  RCWeather+CoreDataProperties.h
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeather+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RCWeather (CoreDataProperties)

+ (NSFetchRequest<RCWeather *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *icon;
@property (nullable, nonatomic, copy) NSString *main;
@property (nullable, nonatomic, retain) RCMap *map;

@end

NS_ASSUME_NONNULL_END
