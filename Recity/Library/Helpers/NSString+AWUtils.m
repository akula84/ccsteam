//
//  NSString+AWUtils.m
//  
//
//  Created by Alexander Kozin on 10.07.15.
//
//

#import "NSString+AWUtils.h"

@implementation NSString (AWUtils)

- (NSString *)classNameFromBackendKey
{
    NSString *classString = [self keyFromBackendKeyWithFirstLetterCapitalization:YES];
    return classString;
}

- (NSString *)propertyFromBackendKey
{
    NSString *propertyName = [self keyFromBackendKeyWithFirstLetterCapitalization:NO];
    return propertyName;
}

- (NSString *)keyFromBackendKeyWithFirstLetterCapitalization:(BOOL)capitalizeFirstLetter
{
    NSString *propertyName = self;

    NSUInteger len = [propertyName length];
    unichar bufferForIteration[len];
    unichar resultBuffer[len];

    [self getCharacters:bufferForIteration range:NSMakeRange(0, len)];

    BOOL shouldCapitalize = capitalizeFirstLetter;

    NSUInteger j = 0;
    for(NSUInteger i = 0; i < len; ++i) {
        unichar current = bufferForIteration[i];
        if (current == '_') {
            shouldCapitalize = YES;
        } else {
            if (shouldCapitalize) {
                current = (unichar)toupper(current);
                shouldCapitalize = NO;
            }

            resultBuffer[j] = current;
            j++;
        }
    }

    propertyName = [[NSString alloc] initWithCharacters:resultBuffer length:j];
    
    return propertyName;
}

- (NSString *)backendKeyFromPropertyName
{
    NSString *propertyName = self;

    NSUInteger len = [propertyName length];
    unichar bufferForIteration[len];
    unichar resultBuffer[len*2];

    [self getCharacters:bufferForIteration range:NSMakeRange(0, len)];

    BOOL insertUnderscoreAfterNextUpLetter = NO;

    NSUInteger j = 0;
    for(NSUInteger i = 0; i < len; ++i) {
        unichar current = bufferForIteration[i];
        if (isupper(current)) {
            if (insertUnderscoreAfterNextUpLetter) {
                resultBuffer[j] = '_';
                j++;

                insertUnderscoreAfterNextUpLetter = NO;
            }
            resultBuffer[j] = (unichar)tolower(current);
        } else {
            insertUnderscoreAfterNextUpLetter = YES;
            resultBuffer[j] = current;
        }

        j++;
    }

    propertyName = [[NSString alloc] initWithCharacters:resultBuffer length:j];
    
    return propertyName;
}

@end
