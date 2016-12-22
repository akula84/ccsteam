//
//  RCDeltaStrategy.m
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDeltaStrategy.h"

@implementation RCDeltaStrategy

- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides
{
    RCFloatViewState *result;
    NSArray *orderedStatesByPositionAscending = self.orderedStatesByPositionAscending;
    NSInteger countStates = (NSInteger)orderedStatesByPositionAscending.count;
    
    NSInteger i = (NSInteger)[[orderedStatesByPositionAscending valueForKey:@"state"] indexOfObject:@(previousState.state)];
    RCFloatViewState *currentState = orderedStatesByPositionAscending[(NSUInteger)i];
    CGFloat currentPositionAtThisState = currentState.positionAtThisState;
    RCFloatViewState *prevState;
    RCFloatViewState *nextState;
    RCFloatViewState *lastState = [orderedStatesByPositionAscending lastObject];
    NSInteger prevI = i - 1;
    if (prevI < countStates && prevI >= 0) {
        prevState = orderedStatesByPositionAscending[(NSUInteger)prevI];
    }
    NSInteger nextI = i + 1;
    if (nextI < countStates) {
        nextState = orderedStatesByPositionAscending[(NSUInteger)nextI];
    }
    if (i == 0) {
        if (position < currentPositionAtThisState + deltaToBothSides) {
            result = currentState;
        } else if (position > nextState.positionAtThisState + deltaToBothSides){
            result = lastState;
        } else {
            result = nextState;
        }
    } else if (i == countStates - 1) {
        if (position > currentPositionAtThisState - deltaToBothSides) {
            result = currentState;
        } else {
            result = prevState;
        }
    } else {
        if (position <= currentPositionAtThisState - deltaToBothSides) {
            result = prevState;
        } else if (position > currentPositionAtThisState + deltaToBothSides) {
            result = nextState;
        } else {
            result = currentState;
        }
    }
    return result;
}

+ (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides orderedStatesByPositionAscending:(NSArray *)orderedStatesByPositionAscending
{
    RCDeltaStrategy *strategy = [RCDeltaStrategy new];
    strategy.orderedStatesByPositionAscending = orderedStatesByPositionAscending;
    return [strategy stateIfDragFinishedAtPosition:position whenPreviousStateWas:previousState deltaToBothSides:deltaToBothSides];
}

@end
