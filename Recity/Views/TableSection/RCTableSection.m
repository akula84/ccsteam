//
//  RCTableSection.m
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTableSection.h"

@implementation RCTableSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = @[];
        _isShowHeader = YES;
    }
    return self;
}

@end
