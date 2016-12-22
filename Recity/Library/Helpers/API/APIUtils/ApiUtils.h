//
//  ApiUtils.h
//  Recity
//
//  Created by Artem Kulagin on 29.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface ApiUtils : NSObject

+ (NSMutableURLRequest *)prepareURLRequest:(NSMutableURLRequest *)request;
+ (void)saveModifiedSince;
+ (BOOL)isHaveProjectsInBase;

@end
