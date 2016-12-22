//
//  AWModel_Private.h
//  
//
//  Created by Alexander Kozin on 11.07.15.
//
//

#import "AWModel.h"

@interface AWModel (Mapping_Private)

+ (NSMutableDictionary *)propertyMapping;
+ (NSMutableDictionary *)classMapping;

+ (void)drainMappings;

@end
