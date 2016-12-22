//
//  RCAreasStrategy.m
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAreasStrategy.h"

@implementation RCAreasStrategy

- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides {
    RCFloatViewState *result;
    
    for (NSUInteger i = 0; i < self.orderedStatesByPositionAscending.count; ++i) {
        RCFloatViewState *currentState = self.orderedStatesByPositionAscending[i];
        if (i == 0) {//     if first
            if (position <= currentState.endPos) {
                result = currentState;
                break;
            }
        } else if (i == self.orderedStatesByPositionAscending.count - 1) {//    if prevlast
            if (currentState.endPos <= position) {
                result = currentState;
                break;
            }
        } else if (currentState.beginPos <= position && position < currentState.endPos) {//      if between
            result = currentState;
            break;
        }
    }
    return result;
}

@end
