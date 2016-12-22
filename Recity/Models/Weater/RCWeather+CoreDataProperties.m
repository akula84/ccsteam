//
//  RCWeather+CoreDataProperties.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeather+CoreDataProperties.h"

@implementation RCWeather (CoreDataProperties)

+ (NSFetchRequest<RCWeather *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RCWeather"];
}

@dynamic icon;
@dynamic main;
@dynamic map;

@end
