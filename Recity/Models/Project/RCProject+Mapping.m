//
//  RCProject+Mapping.m
//  Recity
//
//  Created by Artem Kulagin on 09.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject_Private.h"

@implementation RCProject (Mapping)

- (void)didImport:(id)data
{
    self.architectsData = [NSKeyedArchiver archivedDataWithRootObject:[data objectForKey:@"architects"]];
    self.developersData = [NSKeyedArchiver archivedDataWithRootObject:[data objectForKey:@"developers"]];
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"uid = %@\n",self.uid];
    [string appendFormat:@"address = %@\n",self.address];
    [string appendFormat:@"architectsData = %@\n",self.architects];
    [string appendFormat:@"buildingSize = %@\n",self.buildingSize];
    [string appendFormat:@"completionDate = %@\n",self.completionDate];
    
    [string appendFormat:@"completionTime = %@\n",self.completionTime];
    [string appendFormat:@"constructionType = %@\n",self.constructionType];
    [string appendFormat:@"developersData = %@\n",self.developers];
    [string appendFormat:@"developmentIndex = %@\n",self.developmentIndex];
    [string appendFormat:@"estimatedBuildingSize = %@\n",self.estimatedBuildingSize];
    
    [string appendFormat:@"estimatedFloorCount = %@\n",self.estimatedFloorCount];
    [string appendFormat:@"floorCount = %@\n",self.floorCount];
    [string appendFormat:@"groundBreakingDate = %@\n",self.groundBreakingDate];
    [string appendFormat:@"groundBreakingTime = %@\n",self.groundBreakingTime];
    [string appendFormat:@"landSize = %@\n",self.landSize];
    
    [string appendFormat:@"name = %@\n",self.name];
    [string appendFormat:@"status = %@\n",self.status];
    [string appendFormat:@"cityUID = %@\n",self.cityUID];
    [string appendFormat:@"centerPoint = %@\n",self.centerPoint];
    [string appendFormat:@"images = %@\n",self.imagesString];
    
    [string appendFormat:@"previewImage = %@\n",self.previewImage];
   // [string appendFormat:@"recenterUsers = %@\n",self.recenterUsers];
    [string appendFormat:@"shapes = %@",self.shapesString];
    [string appendFormat:@"tenants = %@\n",self.tenantsString];
    [string appendFormat:@"typeDetails = %@\n",self.typeDetails];
 
 
    return string;
}

- (NSString *)shapesString
{
    NSMutableString *string = [NSMutableString string];
    for (RCShape *shape in self.shapes) {
        [string appendFormat:@"%@\n",shape];
    }
    return string;
}

- (NSString *)imagesString
{
    NSMutableString *string = [NSMutableString string];
    for (RCImage *image in self.images) {
        [string appendFormat:@"%@\n",image];
    }
    return string;
}

- (NSString *)tenantsString
{
    NSMutableString *string = [NSMutableString string];
    for (RCTenant *item in self.tenants) {
        [string appendFormat:@"%@\n",item];
    }
    return string;
}

@end
