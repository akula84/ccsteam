//
//  RCUser.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 11.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"

@implementation RCUser

- (BOOL)hasAdvancedSubscription
{
    return [self.subscriptionType isEqualToString:@"Advanced"];
}
/*
- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"RCUser_______________________\n"];
    
    [string appendFormat:@"authorizationToken %@\n",self.authorizationToken];
    [string appendFormat:@"firstName %@\n",self.firstName];
    [string appendFormat:@"homeCityId %@\n",self.homeCityId];
    [string appendFormat:@"lastName %@\n",self.lastName];
    [string appendFormat:@"login %@\n",self.login];
    
    [string appendFormat:@"role %@\n",self.role];
    [string appendFormat:@"subscriptionType %@\n",self.subscriptionType];
    [string appendFormat:@"userinfo %@\n",self.userinfo];

    
    return string;
}
*/
@end
