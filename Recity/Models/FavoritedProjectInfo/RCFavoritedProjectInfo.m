//
//  RCFavoritedProjectInfo.m
//  
//
//  Created by Matveev on 10/05/16.
//
//

#import "RCFavoritedProjectInfo.h"

#import "RCAddress.h"
#import "RCProject.h"

@implementation RCFavoritedProjectInfo

+ (instancetype)itemWith:(id)model inContext:(NSManagedObjectContext *)context
{
    RCFavoritedProjectInfo *item = [RCFavoritedProjectInfo MR_createEntityInContext:context];
    if ([model isKindOfClass:[RCProject class]]) {
        item.projectUID = ((RCProject *)model).uid;
    }else if ([model isKindOfClass:[RCAddress class]]) {
        RCAddress *locationAddress = (RCAddress *)model;
        item.address = [locationAddress placeNameIsHave];
        item.latitude = locationAddress.latitude;
        item.longitude = locationAddress.longitude;
    }
    return item;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict;
    NSNumber *projectUID = self.projectUID;
    if (projectUID.isFull) {
        dict = @{@"projectId":projectUID};
    } else {
        dict = @{@"location":[self location]};
    }
    return dict;
}

- (NSDictionary *)location
{
    return @{@"address":self.address,
             @"coordinate":[self coordinate]
             };
}

- (NSDictionary *)coordinate
{
    return @{@"latitude":self.latitude,
             @"longitude":self.longitude};
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"          address = %@\n",self.address];
    [string appendFormat:@"          latitude = %@\n",self.latitude];
    [string appendFormat:@"          longitude = %@\n",self.longitude];
    [string appendFormat:@"          projectUID = %@\n",self.projectUID];
    [string appendFormat:@"          uid = %@\n",self.uid];
    
    return string;
}

@end
