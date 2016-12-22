//
//  RCKVCHelper.m
//  Recity
//
//  Created by Artem Kulagin on 07.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCKVCHelper.h"

@implementation RCKVCHelper

+ (NSNumber *)avgForKey:(NSString *)key item:(id)item
{
    NSString *path = [NSString stringWithFormat:@"@avg.%@",key];
    return [item valueForKeyPath:path];
}

@end
