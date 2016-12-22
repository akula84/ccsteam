//
//  RCShape.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

@class RCPoint;

NS_ASSUME_NONNULL_BEGIN

@interface RCShape : RCBaseModel <EKManagedMappingProtocol>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RCShape+CoreDataProperties.h"
