//
//  Utils.m
//  PSB
//
//  Created by Артем Кулагин on 10.04.15.
//  Copyright (c) 2015 Luxoft. All rights reserved.
//

#import "CounterTime.h"

int count_time_start;

NSDateFormatter *dateFormatter(void);
int countDate(void);

void startTimer(void)
{
    count_time_start = countDate();
    NSLog(@"startTimer");
}

void endTimer(void)
{
    NSLog(@"milliseconds %d",countDate() - count_time_start);
}

int countDate(void)
{
    return [[dateFormatter() stringFromDate:[NSDate date]] intValue];
}

NSDateFormatter *dateFormatter(void)
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"A"];
    });
    return dateFormatter;
}
