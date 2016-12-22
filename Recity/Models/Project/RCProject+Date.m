//
//  RCProject+Date.m
//  Recity
//
//  Created by Artem Kulagin on 01.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject.h"

@implementation RCProject (Date)

- (NSString *)completionTimeWithYear
{
    NSString *result = @"";
    if ([self isHaveCompletionDate]) {
        result = [self yearStringFromDateString:self.completionDate];
        if ([self isHaveCompletionTime]) {
            result = [NSString stringWithFormat:@"%@ %@",self.completionTime,result];
        }
    } else {
        result = kTBD;
    }
    return result;
}

- (NSString *)completionDateString
{
    NSString *result;
    if (self.completionDate.length > 0) {
        result = [self quarterWithYearStringFromDate:[self expectedCompletionDate]];
    } else {
        result = kTBD;
    }
    return result;
}

- (BOOL)isHaveCompletionDate
{
    return [self.completionDate isFull];
}

- (BOOL)isHaveCompletionTime
{
    return [self.completionTime isFull];
}

- (NSString *)completionMonthDateString
{
    NSString *result;
    if (self.completionDate.isFull) {
        result = [self monthWithYearStringFromDate:[self expectedCompletionDate]];
    } else {
        result = kTBD;
    }
    return result;
}

- (NSDate *)expectedCompletionDate
{
    return [self dateFromString:self.completionDate];
}


- (BOOL)isHaveGroundbreaking
{
    return [self isHaveGroundbreakingDate]||[self isHaveGroundBreakingTime];
}

- (BOOL)isHaveGroundbreakingDate
{
    return (self.groundBreakingDate.length > 0);
}

- (BOOL)isHaveGroundBreakingTime
{
    return (self.groundBreakingTime.length > 0);
}

- (NSString *)groundbreakingDateString
{
    NSString *result = @"";
    NSDate *groundbreakingDate;
    if ([self isHaveGroundbreakingDate]) {
        groundbreakingDate = [self dateFromString:self.groundBreakingDate];
        result = [self yearStringFromDate:groundbreakingDate];
        if ([self isHaveGroundBreakingTime]) {
            result = [NSString stringWithFormat:@"%@ %@",self.groundBreakingTime,result];
        }
    } else if ([self isHaveGroundBreakingTime]) {
        result = self.groundBreakingTime;
    } else {
        result = kTBD;
    }
    return result;
}

- (NSDate *)dateFromString:(NSString *)dateString {
    NSDate *date = [NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return date;
}

- (NSString *)quarterWithYearStringFromDate:(NSDate *)date {
    NSString *result = [date stringValueWithFormat:@"QQQ yyyy"];
    return result;
}

- (NSString *)monthWithYearStringFromDate:(NSDate *)date {
    NSString *result = [date stringValueWithFormat:@"LLLL yyyy"];
    return result;
}

- (NSString *)yearStringFromDate:(NSDate *)date {
    NSString *result = [date stringValueWithFormat:@"yyyy"];
    return result;
}

- (NSString *)yearStringFromDateString:(NSString *)dateString
{
    NSDate *date = [self dateFromString:dateString];
    return [self yearStringFromDate:date];
}

- (NSInteger)yearNumberFromDateString:(NSString *)dateString
{
    NSString *yearString = [self yearStringFromDateString:dateString];
    return yearString.integerValue;
}

- (NSInteger)completionYear
{
    return [self yearNumberFromDateString:self.completionDate];
}

@end
