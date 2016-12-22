//
//  RCIndexUtils.h
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface RCIndexUtils : NSObject

typedef NS_ENUM(NSInteger, RCGroupType) {
    RCGroupTypeDigit,
    RCGroupTypePlanned,
    RCGroupTypeSqFt
};

+ (NSNumber *)valueResidentialUnits:(NSArray *)array;
+ (NSNumber *)valueRetailSize:(NSArray *)array;
+ (NSNumber *)valueOfficeSize:(NSArray *)array;
+ (NSNumber *)valueBuildingSize:(RCProject *)project;
+ (NSNumber *)valueOfficeAndRetail:(NSArray *)array;

+ (BOOL)aviableArray:(NSArray *)array;

+ (NSString *)yearStringBy:(NSArray *)arrayProject;

@end
