//
//  RCIndexUtils.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCIndexUtils.h"

#import "RCProject.h"
#import "RCPredicateFactory.h"

@implementation RCIndexUtils

+ (NSNumber *)valueResidentialUnits:(NSArray *)array
{
    return [self valueSize:array keyOne:@"numberOfResidentialUnits" keyTwo:@"estimatedNumberOfResidentialUnits"];
}

+ (NSNumber *)valueRetailSize:(NSArray *)array
{
    return [self valueSize:array keyOne:@"retailSize" keyTwo:@"estimatedRetailSize"];
}

+ (NSNumber *)valueOfficeSize:(NSArray *)array
{
    return [self valueSize:array keyOne:@"officeSize" keyTwo:@"estimatedOfficeSize"];
}

+ (NSNumber *)valueOfficeAndRetail:(NSArray *)array
{
    NSNumber *retail = [self valueRetailSize:array];
    NSNumber *office = [self valueOfficeSize:array];
    return @(retail.floatValue + office.floatValue);
}

+ (NSNumber *)valueSize:(NSArray *)array keyOne:(NSString *)keyOne keyTwo:(NSString *)keyTwo
{
    NSString *keySumType =[self keySumTypeDetails];
    NSString *keyNumber = [keySumType stringByAppendingString:keyOne];
    NSString *keyEstimatedNumber = [keySumType stringByAppendingString:keyTwo];
    
    NSNumber *number = [array valueForKeyPath: keyNumber];
    NSNumber *estimatedNumber = [array valueForKeyPath: keyEstimatedNumber];
    if (!number.isFull) {
        number = estimatedNumber;
    }
    return number;
}

+ (NSString *)keySumTypeDetails
{
    return [NSString stringWithFormat:@"@sum.%@.",kTypeDetails];
}

+ (NSNumber *)valueBuildingSize:(RCProject *)project
{
    NSNumber *keyNumber = project.buildingSize;
    NSNumber *keyEstimatedNumber = project.estimatedBuildingSize;
    NSNumber *result = keyNumber;
    if (!result.isFull) {
        result = keyEstimatedNumber;
    }
    return result;
}

+ (BOOL)aviableArray:(NSArray *)array
{
    return array.count >= 2.f;
}

+ (NSString *)yearString:(NSArray *)arrayProject
{
    if ((!arrayProject.isFull)||
        ([self isHaveNull:arrayProject])) {
        return kTBD;
    }
    
    NSInteger maxYear = [arrayProject.firstObject expectedCompletionDate].year;
    for (NSUInteger i = 1; i < arrayProject.count; i++) {
        NSInteger year = [arrayProject[i] expectedCompletionDate].year;
        if (year > maxYear) {
            maxYear = year;
        }
    }
    return [NSString stringWithFormat:@"%@",@(maxYear)];
}

+ (BOOL)isHaveNull:(NSArray *)array
{
    NSPredicate *pred = [RCPredicateFactory predCompletionDateNull];
    return [array filteredArrayUsingPredicate:pred].isFull;
}

+ (NSString *)yearDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%@",@(date.year)];
}

+ (NSString *)yearStringBy:(NSArray *)arrayProject
{
    NSString *result;
    NSString *yearString = [self yearString:arrayProject];
    if ([yearString isEqualToString:kTBD]) {
        result = @"";
    } else {
        result = [NSString stringWithFormat:@" by %@",yearString];
    }
    return result;
}

@end
