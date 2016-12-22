//
//  RCMap+CoreDataProperties.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMap+CoreDataProperties.h"

@implementation RCMap (CoreDataProperties)

+ (NSFetchRequest<RCMap *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RCMap"];
}

@dynamic name;
@dynamic main;
@dynamic weather;

@end
