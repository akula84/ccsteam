//
//  RCFloatViewState.h
//  Recity
//
//  Created by Matveev on 31/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCFloatViewState : NSObject

@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) CGFloat positionAtThisState;
@property (assign, nonatomic) CGFloat beginPos;//       for detect need to turn into this state
@property (assign, nonatomic) CGFloat endPos;//       for detect need to turn into this state

- (instancetype)initWithState:(NSInteger)state positionAtThisState:(CGFloat)positionAtThisState beginPos:(CGFloat)beginPos endPos:(CGFloat)endPos;

@end
