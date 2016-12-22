//
//  RCTenant.h
//  
//
//  Created by Matveev on 29/04/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RCProject;

NS_ASSUME_NONNULL_BEGIN

@interface RCTenant : RCBaseModel <EKManagedMappingProtocol>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RCTenant+CoreDataProperties.h"
