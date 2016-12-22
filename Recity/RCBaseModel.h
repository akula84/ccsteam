//
//  RCBaseModel.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 11.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <EasyMapping/EasyMapping.h>
#import "RCBaseRequest.h"
#import "RCHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCBaseModel : NSManagedObject


@end

NS_ASSUME_NONNULL_END

#import "RCBaseModel+CoreDataProperties.h"
