//
//  API+File.m
//  Wacatch
//
//  Created by Pavel Deminov on 18/03/16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

#import "API_Protected.h"

@implementation API (File)

- (void)addFile:(FileModel*)file
{
    if (!self.files) {
        self.files = [NSMutableArray new];
    }
    
    [self.files addObject:file];
}

@end
