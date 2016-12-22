//
//  RCPredicateFactory+Project.m
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPredicateFactory.h"

@implementation RCPredicateFactory (Project)

+ (NSPredicate *)predProjectPlannedUnderUIds:(NSArray *)array
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@",kUid,array];
    //   NSPredicate *predUnderPlanned = [NSCompoundPredicate orPredicateWithSubpredicates:@[[self predUnder],[self predPlanned]]];
    //  return [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate,predUnderPlanned]]; //NO remove
    return predicate;
}

+ (NSPredicate *)predUnder
{
    return [self predStatus:kUnderConstruction];
}

+ (NSPredicate *)predUpcoming
{
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[[self predPlanned],
                                                               [self predUnder]]];
}

+ (NSPredicate *)predCompleted
{
    return [self predStatus:kCompleted];
}

+ (NSPredicate *)predPlanned
{
    return [self predStatus:kPlanned];
}

+ (NSPredicate *)predUnannounced
{
    return [self predStatus:kUnannounced];
}

+ (NSPredicate *)predStatus:(NSString *)value
{
    return [self predIsEgual:kStatus value:value];
}

+ (NSPredicate *)predTypeDetailsResidential
{
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[[self predApartments],
                                                               [self predCondominiums],
                                                               [self predResidentialTbd]]];
}

+ (NSPredicate *)predTypeDetailsOfficeAndRetail
{
    return [NSCompoundPredicate orPredicateWithSubpredicates:@[[self predTypeDetailsRetail],
                                                               [self predTypeDetailsOffice]]];
}

+ (NSPredicate *)predApartments
{
    return [self predTypeDetails:kApartments];
}

+ (NSPredicate *)predCondominiums
{
    return [self predTypeDetails:kCondominiums];
}

+ (NSPredicate *)predResidentialTbd
{
    return [self predTypeDetails:kResidentialTbd];
}

+ (NSPredicate *)predTypeDetailsCommercial
{
    return [self predTypeDetailsOffice];
//    NSPredicate *office = [self predTypeDetailsOffice];
//    return [NSCompoundPredicate andPredicateWithSubpredicates:@[office, notRetail]];
}

+ (NSPredicate *)predTypeDetailsOffice
{
   return [self predTypeDetails:kOffice];
}

+ (NSPredicate *)predTypeDetailsEntertainment
{
    return [self predTypeDetails:kEntertainment];
}

+ (NSPredicate *)predTypeDetailsRetail
{
    return [self predTypeDetails:kRetail];
}

+ (NSPredicate *)predTypeDetailsHotel
{
    return [self predTypeDetails:kHotel];
}

+ (NSPredicate *)predTypeDetailsOther
{
    return [self predTypeDetails:kOther];
}

+ (NSPredicate *)predTypeDetails:(NSString *)value
{
    return [NSPredicate predicateWithFormat:@"%K.%K == %@",kTypeDetails,value,@(YES)];
}

+ (NSPredicate *)predCompletionDateNull
{
    return [NSPredicate predicateWithFormat:@"%K == null",kCompletionDate];
}

@end
