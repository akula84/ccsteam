//
//  RCShape+Mapping.m
//  Recity
//
//  Created by Artem Kulagin on 09.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCShape_Private.h"

#import "RCPoint.h"

@implementation RCShape (Mapping)

- (void)didImport:(id)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in [data objectForKey:@"points"]) {
        [array addObject:[RCPoint itemWithDict:dict inContext:self.managedObjectContext]];
    }
    self.shapePoints = [NSOrderedSet orderedSetWithArray:array];
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________ %@\n",@(self.shapePoints.count)];
    
    for (RCPoint *point in  self.shapePoints) {
       [string appendFormat:@" %@\n",point];
    }
    
    return string;
}

- (void)shapePointsSet:(id)object
{
    [self addShapePoints:object];
}

@end
