//
//  NSDate+Utils.m
//  neemble
//
//  Created by Artem Kulagin on 23.12.15.
//  Copyright © 2015 El-Machine. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSDate *)dateByAddingPeriod:(NSDatePeriodType)type
{
    return [self dateByChangePeriod:type value:1];
}

- (NSDate *)dateByBackPeriod:(NSDatePeriodType)type
{
   return [self dateByChangePeriod:type value:-1];
}

- (NSDate *)dateByChangePeriod:(NSDatePeriodType)type value:(NSInteger)value
{
    NSCalendarUnit unit;
    switch (type) {
        case NSDatePeriodDay:
            unit = NSCalendarUnitDay;
            break;
        case NSDatePeriodMonth:
            unit = NSCalendarUnitMonth;
            break;
        case NSDatePeriodYear:
            unit = NSCalendarUnitYear;
            break;
        default:
            break;
    }
    return [self.currentCalendar dateByAddingUnit:unit value:value toDate:self options:(NSCalendarOptions)0];
}

- (NSCalendar *)currentCalendar
{
    static NSCalendar *currentCalendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentCalendar = [NSCalendar currentCalendar];
    });
    return currentCalendar;
}

@end
