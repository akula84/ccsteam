//
//  NSNumber+GroupedThreeDigit.m
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSNumber+Grouped.h"

@implementation NSNumber (Grouped)

- (NSString *)groupDigit
{
    return [[self formatterGroup] stringFromNumber:self];
}

- (NSString *)groupPlanned
{
    float floatValue = self.floatValue;
    NSString *result;
    if (floatValue < 1000) {
        result = [self resultHundred];
    }else if ((1000 <= floatValue)&&(floatValue < 1000000)) {
        result = [self resultThousand];
    }else if (1000000 <= floatValue) {
        result = [self resultMillone];
    }
    return result;
}

- (NSString *)groupSqFT
{
    float floatValue = self.floatValue;
    NSString *result;
    if (floatValue < 1000000) {
        result = [self resultHundred];
    }else if (1000000 <= floatValue) {
        result = [self resultMillone];
    }
    return result;
}

- (NSString *)resultHundred
{
    return [self roundFirstTwoSymbol];
}

- (NSString *)resultThousand
{
    float floatValue = roundf(self.floatValue/1000);
    NSString *roundFirstTwo = [@(floatValue) roundFirstTwoSymbol];
    return  [NSString stringWithFormat:@"%@K",roundFirstTwo];
}

- (NSString *)resultMillone
{
   float floatValue = self.floatValue/1000000;
   NSString *roundOne = [@(floatValue) roundOneDecimal];
   return [NSString stringWithFormat:@"%@M",roundOne];
}

- (NSString *)roundFirstTwoSymbol
{
    NSNumberFormatter *formatter = [self formatterGroup];
    formatter.maximumSignificantDigits = 2;
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    return [formatter stringFromNumber:self];
}

- (NSString *)roundOneDecimalUp
{
    NSNumberFormatter *formatter = [self formatterGroup];
    formatter.minimumIntegerDigits = 1;
    formatter.minimumFractionDigits = 1;
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    formatter.decimalSeparator = @".";
    return [formatter stringFromNumber:self];
}

- (NSString *)roundOneDecimal
{
    NSNumberFormatter *formatter = [self formatterGroup];
    formatter.minimumFractionDigits = 1;
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    formatter.decimalSeparator = @".";
    return [formatter stringFromNumber:self];
}

- (NSNumberFormatter *)formatterGroup
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [formatter setUsesGroupingSeparator:YES];
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    return formatter;
}

@end
