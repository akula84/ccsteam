//
//  NMBUserDefaultsController.h
//  neemble
//
//  Created by Artem Kulagin on 04.03.16.
//  Copyright © 2016 El-Machine. All rights reserved.
//

@interface RCUserDefaults : NSObject

+ (NSDate *)modifiedSince;
+ (void)saveModifiedSince:(NSDate *)date;

@end
