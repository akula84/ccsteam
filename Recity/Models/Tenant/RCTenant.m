//
//  RCTenant.m
//  
//
//  Created by Matveev on 29/04/16.
//
//

#import "RCTenant.h"

@implementation RCTenant

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"     name  = %@\n",self.name];
    [string appendFormat:@"     type = %@\n",self.type];
    
    return string;
}

@end
