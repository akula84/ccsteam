//
//  RCTutorialPageModel.m
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTutorialPageModel.h"

@implementation RCTutorialPageModel

- (BOOL)isEqual:(RCTutorialPageModel *)object
{
    return ([self.title isEqualToString:object.title] && [self.text isEqualToString:object.text]);
}

- (NSUInteger)hash
{
    return self.title.hash + self.text.hash;
}

@end
