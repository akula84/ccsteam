//
//  RCAreasStrategy.h
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCDragStateChangingStrategy.h"
#import "RCFloatViewState.h"

//       free space splitted on areas. When drag finished floatView will turned into state accorded with area where it appeared. e.g. points when in state: state1=0, state2=150, state3 = 300. And areas: [0-100)=state1,[100-200)=state2,[200-300]=state3 then if drag finished at position 210 then go to state3. if finished at 60 then go to state1
@interface RCAreasStrategy : RCDragStateChangingStrategy

- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides;

@end
