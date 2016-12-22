//
//  NSDate+Utils.h
//  neemble
//
//  Created by Artem Kulagin on 23.12.15.
//  Copyright © 2015 El-Machine. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NSDatePeriodType) {
    NSDatePeriodDay,
    NSDatePeriodMonth,
    NSDatePeriodYear,
};


@interface NSDate (Utils)

- (NSDate *)dateByBackPeriod:(NSDatePeriodType)type;
- (NSDate *)dateByAddingPeriod:(NSDatePeriodType)type;

@end
