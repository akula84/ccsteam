//
//  RCPoint.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RCShape, RCPoint;

@interface RCPoint : RCBaseModel <EKManagedMappingProtocol>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RCPoint+CoreDataProperties.h"
