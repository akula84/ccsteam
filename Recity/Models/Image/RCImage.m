//
//  RCImage.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCImage.h"

@implementation RCImage

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    [string appendFormat:@"url %@\n",self.url];
    [string appendFormat:@"width %@\n",self.width];
    [string appendFormat:@"height %@\n",self.height];
       
    return string;
}

@end
