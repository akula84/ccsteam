//
//  RCProjectDetail.m
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetail.h"

@implementation RCProjectDetail

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

@end
