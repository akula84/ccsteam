//
//  AWMissedProperties.m
//  
//
//  Created by Alexander Kozin on 10.07.15.
//
//

#import "AWMissedProperties.h"

#import "NSObject+ClassName.h"

@interface AWMissedProperties ()

@property (strong, nonatomic) NSMutableString *missedProperties;

@end

@implementation AWMissedProperties

@dynamic missedProperties;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareMissedProperties];
    }
    return self;
}

+ (instancetype)objectFromDictionary:(NSDictionary*)source
{
    AWMissedProperties *object = [super objectFromDictionary:source];
    [object parsingDidEnd];

    return object;
}

- (BOOL)safelySetValue:(id)value forKey:(NSString *)key
{
    BOOL isSet = [super safelySetValue:value forKey:key];
    if (!isSet) {
        Class valueClass = [value class];
        NSString *missedProperty = [NSString stringWithFormat:@"\n@property (copy, nonatomic) %@ *%@;",
                                    [valueClass rc_className],
                                    key];

        [self.missedProperties appendString:missedProperty];
    }

    return isSet;
}

- (void)prepareMissedProperties
{
    NSString *string = [NSString stringWithFormat:@"\n@interface %@ : %@ \n",
                        NSStringFromClass([self class]),
                        NSStringFromClass([AWModelClass class])];
    [self setMissedProperties:[NSMutableString stringWithString:string]];
}

- (void)parsingDidEnd
{
    NSMutableString *missedProperties = self.missedProperties;
    [missedProperties appendString:@"\n\n@end \n"];

    NSLog(@"%@", self.missedProperties);
}

@end
