//
//  RCMap+CoreDataProperties.h
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMap+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RCMap (CoreDataProperties)

+ (NSFetchRequest<RCMap *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) RCMain *main;
@property (nullable, nonatomic, retain) NSSet<RCWeather *> *weather;

@end

@interface RCMap (CoreDataGeneratedAccessors)

- (void)addWeatherObject:(RCWeather *)value;
- (void)removeWeatherObject:(RCWeather *)value;
- (void)addWeather:(NSSet<RCWeather *> *)values;
- (void)removeWeather:(NSSet<RCWeather *> *)values;

@end

NS_ASSUME_NONNULL_END
