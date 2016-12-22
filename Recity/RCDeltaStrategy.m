//
//  RCDeltaStrategy.m
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDeltaStrategy.h"

@implementation RCDeltaStrategy

- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides {
    RCFloatViewState *result;
    
    NSInteger i = [[self.orderedStatesByPositionAscending valueForKey:@"state"] indexOfObject:@(previousState.state)];
    RCFloatViewState *currentState = self.orderedStatesByPositionAscending[i];
    RCFloatViewState *prevState;
    RCFloatViewState *nextState;
    RCFloatViewState *lastState = [self.orderedStatesByPositionAscending lastObject];
    if (i - 1 < self.orderedStatesByPositionAscending.count && i - 1 > -1) {
        prevState = self.orderedStatesByPositionAscending[i - 1];
    }
    if (i + 1 < self.orderedStatesByPositionAscending.count) {
        nextState = self.orderedStatesByPositionAscending[i + 1];
    }
    if (i == 0) {//     if first
        if (position < currentState.positionAtThisState + deltaToBothSides) {
            result = currentState;
        } else if (position > nextState.positionAtThisState + deltaToBothSides){//      when from fullscreen want to hide once
            result = lastState;
        } else {
            result = nextState;
        }
    } else if (i == self.orderedStatesByPositionAscending.count - 1) {//        if last
        if (position > currentState.positionAtThisState - deltaToBothSides) {
            result = currentState;
        } else {
            result = prevState;
        }
    } else {
        if (position <= currentState.positionAtThisState - deltaToBothSides) {
            result = prevState;
        } else if (position > currentState.positionAtThisState + deltaToBothSides) {
            result = nextState;
        } else {
            result = currentState;
        }
    }
    return result;
}

@end
