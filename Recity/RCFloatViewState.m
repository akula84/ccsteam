//
//  RCFloatViewState.m
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewState.h"

@implementation RCFloatViewState

- (instancetype)initWithState:(NSInteger)state positionAtThisState:(CGFloat)positionAtThisState beginPos:(CGFloat)beginPos endPos:(CGFloat)endPos {
    self = [super init];
    if (self) {
        self.state = state;
        self.positionAtThisState = positionAtThisState;
        self.beginPos = beginPos;
        self.endPos = endPos;
    }
    return self;
}
@end
