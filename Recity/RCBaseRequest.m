//
//  RCBaseRequest.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 08.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseRequest.h"

@implementation RCBaseRequest

- (NSString *)methodString {
    if (_methodString) {
        return _methodString;
    }
    switch (_method) {
        case RCHTTPMethodPost: {
            _methodString = @"POST";
            break;
        }
        case RCHTTPMethodPut: {
            _methodString = @"PUT";
            break;
        }
        case RCHTTPMethodGet: {
            _methodString = @"GET";
            break;
        }
        case RCHTTPMethodDelete: {
            _methodString = @"DELETE";
            break;
        }
    }
    
    return _methodString;
}

@end
