//
//  RCDeltaStrategy.h
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCDragStateChangingStrategy.h"
#import "RCFloatViewState.h"

//       we orienting on position of floatView at every of states. if drag finished at posotion which more or lesser than position of current state on some delta, then we should go to accorded nearest state. e.g. points when in state: state1=0, state2=150, state3 = 300 and given delta is 30. So when we at state2, if drag will finished at [120-150) then go to state1, else if it finished at [150-180) then go to state3. If we at state1 so if it will finished at [0-30) then go to state2.
@interface RCDeltaStrategy : RCDragStateChangingStrategy

- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides;

+ (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides orderedStatesByPositionAscending:(NSArray *)orderedStatesByPositionAscending;

@end
