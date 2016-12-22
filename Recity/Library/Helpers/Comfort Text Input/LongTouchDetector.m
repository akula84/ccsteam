//
//  Copyright (c) 2015 Denis Matveev. All rights reserved.
//


#import "LongTouchDetector.h"


@interface LongTouchDetector () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *targetView;
@property (strong, nonatomic) UILongPressGestureRecognizer *recognizer;
@property (nonatomic) CGPoint startPoint;

@end

@implementation LongTouchDetector

- (instancetype)init {
    self = [super init];
    if (self) {
        _passTouchEventThroughSelf = YES;
        _maxDistanceBetweenStartEndPointsForCallAction = 12;
    }
    return self;
}

- (void)attachToTargetView:(UIView *)targetView {
    _targetView = targetView;
    
    UIView *sTargetView = _targetView;
    _recognizer = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    if (_minimumRequiredPressDuration) {
        _recognizer.minimumPressDuration = _minimumRequiredPressDuration.doubleValue;
    } else {
        _recognizer.minimumPressDuration = 0.5;
    }
    self.delayedSelection = NO;
    _recognizer.cancelsTouchesInView = !_passTouchEventThroughSelf;
    _recognizer.delegate = self;
    [sTargetView addGestureRecognizer:_recognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    UIView *sTargetView = _targetView;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _touchInProgress = YES;
//        NSLog(@"LONG TAP TOUCH DOWN DETECTED");
        _startPoint = [recognizer locationInView:sTargetView];
        if (_didFinishedWithTouchDownAtTargetViewLocationBlock) {
            _didFinishedWithTouchDownAtTargetViewLocationBlock(_startPoint);
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"LONG TAP TOUCH UP DETECTED");
        _touchInProgress = NO;
        CGPoint endPoint = [recognizer locationInView:sTargetView];
        BOOL willCallAction = [self distanceBetweenPoint:_startPoint endPointEnoughForCallAction:endPoint];
        if (willCallAction) {
            if (_didFinishedWithTouchUpAtTargetViewLocationBlock) {
                _didFinishedWithTouchUpAtTargetViewLocationBlock(_startPoint);
            }
        }
    }
}

- (BOOL)distanceBetweenPoint:(CGPoint)startPoint endPointEnoughForCallAction:(CGPoint)endPoint {
    BOOL result;
    BOOL distanceEnoughForActionByX = ABS(endPoint.x - startPoint.x) < _maxDistanceBetweenStartEndPointsForCallAction;
    BOOL distanceEnoughForActionByY = ABS(endPoint.y - startPoint.y) < _maxDistanceBetweenStartEndPointsForCallAction;
    result = distanceEnoughForActionByX && distanceEnoughForActionByY;
//    NSLog(@"BY X %@ - %@ = %@    %@",@(endPoint.x),@(startPoint.x),@(ABS(endPoint.x - startPoint.x)),@(_maxDistanceBetweenStartEndPointsForCallAction));
//    NSLog(@"BY Y %@ - %@ = %@    %@",@(endPoint.y),@(startPoint.y),@(ABS(endPoint.y - startPoint.y)),@(_maxDistanceBetweenStartEndPointsForCallAction));
    return result;
}

- (void)setDelayedSelection:(BOOL)delayedSelection {
    _recognizer.delaysTouchesBegan = delayedSelection;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return _passTouchEventThroughSelf;
}

@end
