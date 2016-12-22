//
//  DeleteAPI.m
//  
//
//  Created by Arkadiy Tsoy on 10.11.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "DeleteAPI.h"
#import "API_Protected.h"

@implementation DeleteAPI

- (NSString*)method
{
    return @"DELETE";
}

- (NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [super parameters];
    [parameters addEntriesFromDictionary:[self.object fullObject]];
    
    return parameters;
}

@end
