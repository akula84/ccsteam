//
//  RCPoint.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPoint.h"

@implementation RCPoint

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"     latitude  = %@\n",self.latitude];
    [string appendFormat:@"     longitude = %@\n",self.longitude];
    
    return string;
}

+ (instancetype)itemWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
    RCPoint *item = [RCPoint MR_createEntityInContext:context];
    item.latitude = dict[@"latitude"];
    item.longitude = dict[@"longitude"];
    return item;
}

@end
