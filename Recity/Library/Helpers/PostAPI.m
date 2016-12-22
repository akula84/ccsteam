//
//  PostAPI.m
//
//  Created by Alexander Kozin on 3/13/13.
//  Copyright (c) 2013 Alexander Kozin. All rights reserved.
//

#import "PostAPI.h"
#import "API_Protected.h"

@implementation PostAPI

- (NSString*)method
{
    return @"POST";
}

- (void)prepareURLRequest:(NSMutableURLRequest *)request
{
    [super prepareURLRequest:request];

    // Set higher timeout for post requests
    // Default is 20
    [request setTimeoutInterval:60.0];
}

- (NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [super parameters];
//    [parameters addEntriesFromDictionary:[self.object fullObject]];

    return parameters;
}

@end
