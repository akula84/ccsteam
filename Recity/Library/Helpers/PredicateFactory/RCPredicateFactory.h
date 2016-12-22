//
//  RCPredicateFactory.h
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface RCPredicateFactory : NSObject

+ (NSPredicate *)predUid:(id)uid;
+ (NSPredicate *)predIsEgual:(NSString *)nameProperty value:(NSString *)value;
+ (NSPredicate *)predIsKind:(Class)aClass;
+ (NSPredicate *)predAddressLatitude:(id)latitude longitude:(id)longitude;

@end

@interface RCPredicateFactory (Project)

+ (NSPredicate *)predProjectPlannedUnderUIds:(NSArray *)array;
+ (NSPredicate *)predUpcoming;
+ (NSPredicate *)predPlanned;
+ (NSPredicate *)predUnder;
+ (NSPredicate *)predUnannounced;
+ (NSPredicate *)predCompleted;

+ (NSPredicate *)predTypeDetailsResidential;
+ (NSPredicate *)predTypeDetailsCommercial;
+ (NSPredicate *)predTypeDetailsOffice;
+ (NSPredicate *)predTypeDetailsRetail;
+ (NSPredicate *)predTypeDetailsHotel;
+ (NSPredicate *)predTypeDetailsEntertainment;
+ (NSPredicate *)predTypeDetailsOther;
+ (NSPredicate *)predTypeDetailsOfficeAndRetail;

+ (NSPredicate *)predApartments;
+ (NSPredicate *)predCondominiums;
+ (NSPredicate *)predResidentialTbd;
+ (NSPredicate *)predCompletionDateNull;

@end
