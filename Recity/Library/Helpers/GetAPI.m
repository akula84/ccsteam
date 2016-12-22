//
//  GetAPI.m
//
//  Created by Alexander Kozin on 3/13/13.
//  Copyright (c) 2013 Alexander Kozin. All rights reserved.
//

#import "GetAPI.h"
#import "API_Protected.h"
#import "NSDate+Utils.h"

@implementation GetAPI

- (NSString *)method
{
    return @"GET";
}

- (NSString *)pathWithParameters:(NSDictionary*)parameters
{
    NSMutableString *path = [NSMutableString stringWithString:[self path]];
    [path appendString:@"?"];
    [path appendString:[self parametersStringForParameters:parameters]];

    return path;
}

- (NSString*)parametersStringForParameters:(NSDictionary*)parameters
{
    NSMutableString *parametersString = [[NSMutableString alloc] init];
    for (NSString *parameter in parameters.allKeys) {
        [parametersString appendFormat:@"%@=%@&", parameter, parameters[parameter]];
    }
    
    return [parametersString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];
}

@end
