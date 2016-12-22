//
//  RCDragStateChangingStrategy.h
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCFloatViewState.h"

@interface RCDragStateChangingStrategy : NSObject

@property (strong, nonatomic) NSArray *orderedStatesByPositionAscending;//      0, 50, 150, 330, 455 etc.

//      should to rewrite
- (RCFloatViewState *)stateIfDragFinishedAtPosition:(NSInteger)position whenPreviousStateWas:(RCFloatViewState *)previousState deltaToBothSides:(CGFloat)deltaToBothSides;

@end
