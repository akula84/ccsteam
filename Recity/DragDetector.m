//
//  DragDetector.m
//  ImageFilters
//
//  Created by Denis Matveev on 05/06/14.
//  Copyright (c) 2014 Denis Matveev. All rights reserved.
//

#import "DragDetector.h"
//#import "MobileUsable.h"

@interface DragDetector () <UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *_touchDownRecognizer;
    UIPanGestureRecognizer *_panRecognizer;
    
    CGPoint _lastTouchDownPoint;
    CGPoint _panRecognizedAtPoint;
    
    BOOL _canHandleDrag;//       возможно попытаемся обработать драг
    BOOL _willHandleDrag;//     определенно будем обрабатывать драг
}

@property (nonatomic, strong) UIView *fundamentView;

@end

@implementation DragDetector

#pragma mark - Life

- (id)initWithFundamentView:(UIView *)fundamentView
{
    self = [super init];
    if (self) {
        _fundamentView = fundamentView;
        [self prepareGestureRecognizers];
    }
    return self;
}

#pragma mark - Life Private

- (void)prepareGestureRecognizers
{
    _enabled = YES;
    _dragInProgress = NO;
    [self addGestureRecognizers];
}

- (void)addGestureRecognizers
{
    _touchDownRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchDown:)];
    _touchDownRecognizer.cancelsTouchesInView = NO;
    _touchDownRecognizer.delegate = self;
    _touchDownRecognizer.minimumPressDuration = 0.0;
    [_fundamentView addGestureRecognizer:_touchDownRecognizer];
    
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    _panRecognizer.cancelsTouchesInView = NO;
    _panRecognizer.delegate = self;
    [_panRecognizer setMinimumNumberOfTouches:1];
    [_panRecognizer setMaximumNumberOfTouches:1];
    [_fundamentView addGestureRecognizer:_panRecognizer];
}

#pragma mark - Recognizers

- (void)touchDown:(id)sender
{
    UILongPressGestureRecognizer *touchDownRecognizer = (UILongPressGestureRecognizer*)sender;
    if (_enabled) {
        if (touchDownRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint location = [touchDownRecognizer locationInView:_fundamentView];
            _lastTouchDownPoint = location;
            
            if (_canHandleDragWhenTouchDownAtLocationBlock) {
                _canHandleDrag = _canHandleDragWhenTouchDownAtLocationBlock(location);
            } else {
                _canHandleDrag = NO;
            }
        }
    }
}

- (void)move:(id)sender
{
    UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer*)sender;
    if (_canHandleDrag) {
        if (panRecognizer.state == UIGestureRecognizerStateBegan) {
            CGPoint location = [panRecognizer locationInView:_fundamentView];
            _panRecognizedAtPoint = location;
            
            BOOL movedLeft = _lastTouchDownPoint.x - location.x > 0.0;
            
            CGPoint suitableAxisXPositiveVectorP1 = CGPointMake(0.0, 0.0);
            CGPoint suitableAxisXPositiveVectorP2;
            
            if (movedLeft) {
                suitableAxisXPositiveVectorP2 = CGPointMake(-1.0, 0.0);
            } else {
                suitableAxisXPositiveVectorP2 = CGPointMake(1.0, 0.0);
            }
            CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX = [DragDetector angleBetweenVectorOneWithPointOne:_lastTouchDownPoint withPointTwo:location andVectorTwoWithPointThree:suitableAxisXPositiveVectorP1 withPointFour:suitableAxisXPositiveVectorP2];
            //CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX = [MobileUsable lesserPositiveAngleInDegreesBetweenVectorOneWithPointOne:_lastTouchDownPoint withPointTwo:location andVectorTwoWithPointThree:suitableAxisXPositiveVectorP1 withPointFour:suitableAxisXPositiveVectorP2];
            
            if (_willHandleDragWhenPanRecognizedAtLocationBlock) {
                _willHandleDrag = _willHandleDragWhenPanRecognizedAtLocationBlock(location, lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX);
            } else {
                _willHandleDrag = NO;
            }
            
            if (_willHandleDrag) {
                _dragInProgress = YES;
                if (_dragBeganFromLocationBlock) {
                    _dragBeganFromLocationBlock(location, _lastTouchDownPoint, _panRecognizedAtPoint);
                }
            }
        } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
            if (_enabled && _willHandleDrag) {
                //TFLog(@"DRAG IN PROGRESS %i",_dragInProgress);
                CGPoint location = [panRecognizer locationInView:_fundamentView];
                if (_dragLocationChangedBlock) {
                    _dragLocationChangedBlock(location, _lastTouchDownPoint, _panRecognizedAtPoint);
                }
            }
        } else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
            if (_enabled && _willHandleDrag) {
                _willHandleDrag = NO;
                _dragInProgress = NO;
                
                CGPoint location = [panRecognizer locationInView:_fundamentView];
                if (_dragFinishedAtLocationBlock) {
                    _dragFinishedAtLocationBlock(location,_lastTouchDownPoint);
                }
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    return YES;
}

+ (CGFloat)angleBetweenVectorOneWithPointOne:(CGPoint)pointOne withPointTwo:(CGPoint)pointTwo andVectorTwoWithPointThree:(CGPoint)pointThree withPointFour:(CGPoint)pointFour
{
    CGFloat angle1 = atan2(pointOne.y - pointTwo.y, pointOne.x - pointTwo.x);
    CGFloat angle2 = atan2(pointThree.y - pointFour.y, pointThree.x - pointFour.x);
    CGFloat resultPositiveAngle = ABS((angle1-angle2)*180/M_PI);
    if (resultPositiveAngle > 180.0) {
        resultPositiveAngle = 360.0 - ABS(resultPositiveAngle);
    }
    return resultPositiveAngle;
}

@end
