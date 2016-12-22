//
//  RCPoint.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RCShape, RCPoint;

@interface RCPoint : RCBaseModel

+ (instancetype)itemWithDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "RCPoint+CoreDataProperties.h"
