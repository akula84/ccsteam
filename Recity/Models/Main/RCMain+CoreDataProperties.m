//
//  RCMain+CoreDataProperties.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMain+CoreDataProperties.h"

@implementation RCMain (CoreDataProperties)

+ (NSFetchRequest<RCMain *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RCMain"];
}

@dynamic temp;
@dynamic weater;

@end
