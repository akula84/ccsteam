//
//  ApiUtils.m
//  Recity
//
//  Created by Artem Kulagin on 29.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "ApiUtils.h"

#import "RCUserDefaults.h"
#import "RCProject.h"

@implementation ApiUtils

+ (NSMutableURLRequest *)prepareURLRequest:(NSMutableURLRequest *)request
{
    NSDate *date = [RCUserDefaults modifiedSince];
    if (!date||![self isHaveProjectsInBase]) {
        date = [NSDate dateWithTimeIntervalSince1970:0];
    }
    NSString *stringDate = [NSString stringWithFormat:@"%@",date];
    [request setValue:stringDate forHTTPHeaderField:@"Recity-Modified-Since"];
    return request;
}

+ (BOOL)isHaveProjectsInBase
{
    return [RCProject MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]]?YES:NO;
}

+ (void)saveModifiedSince
{
    [RCUserDefaults saveModifiedSince:[NSDate date]];
}

@end
