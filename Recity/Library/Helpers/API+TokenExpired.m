//
//  API+TokenExpired.m
//  
//
//  Created by Sergey Lyubeznov on 09/11/15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "API_Protected.h"

@implementation API (TokenExpired)

- (BOOL)tokenIsExpired
{
    return self.lastError.code == -1011;
}

@end
