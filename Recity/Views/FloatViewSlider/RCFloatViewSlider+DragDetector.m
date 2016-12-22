//
//  RCFloatViewSlider+DragDetector.m
//  Recity
//
//  Created by Artem Kulagin on 25.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSlider_Private.h"

#import "DragDetector.h"
#import "RCDetailsPageController.h"
#import "RCMainTablesScrollView.h"
#import "RCDeltaStrategy.h"

@implementation RCFloatViewSlider (DragDetector)

- (void)addDragDetector
{
    self.dragDetector = [[DragDetector alloc] initWithFundamentView:self.floatView];
    self.dragDetector.enabled = YES;
    
    @weakify(self);
    self.dragDetector.canHandleDragWhenTouchDownAtLocationBlock = ^(CGPoint location) {
       @strongify(self);
       BOOL result = [self canHandleDragWhenTouchDownAtLocationBlock:location];
       return result;
    };
    self.dragDetector.willHandleDragWhenPanRecognizedAtLocationBlock = ^(CGPoint touchDownPoint, CGPoint panRecognizedAtPoint, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX) {
        @strongify(self);
        
        BOOL result = [self willHandleDragWhenPanRecognizedAtLocationBlock:touchDownPoint panRecognizedAtPoint:panRecognizedAtPoint lesser:lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX];
        self.detailPager.scrollEnabled = YES;
        return result;
    };
    self.dragDetector.dragLocationChangedBlock = ^(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint) {
        @strongify(self);
        [self dragLocationChangedBlock:location touchDownPoint:touchDownPoint panRecognizedAtPoint:panRecognizedAtPoint];
        
    };
    self.dragDetector.dragFinishedAtLocationBlock = ^{
        @strongify(self);
        [self dragFinishedAtLocationBlock];
    };
}

- (BOOL)canHandleDragWhenTouchDownAtLocationBlock:(CGPoint)location
{
    FloatViewState displayedState = [self displayedState];
    BOOL result = NO;
    CGPoint translatedLocation = [UIView pointAtScreenCoordinates:location usedAtView:self.floatView];
    CGRect translatedFloatViewFrame = [self.floatView viewFrameAtScreenCoordinates];
    CGRect translatedFloatViewHeaderViewFrame = translatedFloatViewFrame;
    if (displayedState == FloatViewStateMenuFullscreen
        || displayedState == FloatViewStateMenuHalfscreen) {
        translatedFloatViewHeaderViewFrame.size.height = 50;
    } else {
    }
    if (CGRectContainsPoint(translatedFloatViewHeaderViewFrame, translatedLocation)) {
        result = YES;
        self.floatView.userInteractionEnabled = NO;
        self.floatView.userInteractionEnabled = YES;
        self.scrollView.scrollEnabled = NO;
    }
    return result;
}


- (BOOL)willHandleDragWhenPanRecognizedAtLocationBlock:(CGPoint)touchDownPoint panRecognizedAtPoint:(CGPoint)panRecognizedAtPoint
                                                lesser:(CGFloat)lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX
{
    BOOL isDown = (panRecognizedAtPoint.y - touchDownPoint.y > 0);
    
    if (![self canOpenFullscreen] && !isDown) {
        return NO;
    }
    if (lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX < 35.0f) {
        return NO;
    }

    BOOL result = YES;
    self.floatView.height = [self maximumFreeHeight];
    
    CGPoint translatedLocation = [UIView pointAtScreenCoordinates:touchDownPoint usedAtView:self.floatView];
    CGRect translatedFloatViewFrame = [self.floatView viewFrameAtScreenCoordinates];
    CGRect translatedFloatViewHeaderViewFrame = translatedFloatViewFrame;
    translatedFloatViewHeaderViewFrame.size.height = 50;
    
    if (CGRectContainsPoint(translatedFloatViewHeaderViewFrame, translatedLocation)) {
        
    } else {
        BOOL startDragDirectionIsToBottom = panRecognizedAtPoint.y > touchDownPoint.y;
        
        UITableView *table = self.projectDetailsTableView;
        
        if ([self displayedState] == FloatViewStateDetailsFullscreen) {
            if (startDragDirectionIsToBottom) {
                
                BOOL willDrag = [Utils floatNumber:table.contentOffset.y isEqualToFloatNumber:0];
                if (willDrag) {
                    table.scrollEnabled = NO;
                    table.userInteractionEnabled = NO;
                    table.userInteractionEnabled = YES;
                } else {
                    result = NO;
                    table.scrollEnabled = YES;
                }
            } else {
                table.scrollEnabled = YES;
                result = NO;
            }
        } else if ([self displayedState] == FloatViewStateDetailsHalfscreen) {
        }
    }
    return result;
}

- (void)dragLocationChangedBlock:(CGPoint)location touchDownPoint:(CGPoint)touchDownPoint panRecognizedAtPoint:(CGPoint)panRecognizedAtPoint
{
    CGFloat newContentViewY = self.floatView.y + (location.y - touchDownPoint.y) - (panRecognizedAtPoint.y - touchDownPoint.y);
    
    CGFloat currY = self.floatView.y;
    
    if (newContentViewY < [self floatViewFullDisplayedY]) {
        self.floatView.y = [self floatViewFullDisplayedY];
    } else {
        self.floatView.y = newContentViewY;
    }
    
    self.floatViewHeightConstraint.constant += (currY - self.floatView.y);
}

- (void)dragFinishedAtLocationBlock
{
    FloatViewState newFloatViewState = [self newFloatViewState];
    
    if (newFloatViewState == FloatViewStateHidden) {
        [self hideFloatViewAnimatedCompletion:nil];
    } else {
        [self displayFloatViewInState:newFloatViewState animated:YES timeInterval:nil completion:nil];
    }
}

- (FloatViewState)newFloatViewState
{
    RCFloatViewState *prevState = [self state:self.lastStableFloatViewState  position:0.f];
    CGPoint translatedFloatViewOrigin = [self.floatView viewOriginAtScreenCoordinates];
    return [RCDeltaStrategy stateIfDragFinishedAtPosition:(NSInteger)translatedFloatViewOrigin.y whenPreviousStateWas:prevState deltaToBothSides:20.f orderedStatesByPositionAscending:[self orderedStatesByPositionAscending]].state;
}

- (NSArray *)orderedStatesByPositionAscending
{
    RCFloatViewState *hidden = self.hidden;
    
    NSArray *orderedStatesByPositionAscending;
    if (self.beforeDragWasDisplayedAsMenu) {
        orderedStatesByPositionAscending = @[self.fullscreenMenu, self.halfscreenMenu, hidden];
    } else {
        NSMutableArray *states = [@[hidden] mutableCopy];
        if ([self canOpenHalfscreen]) {
            [states insertObject:self.halfscreenDetails atIndex:0];
        }
        if ([self canOpenFullscreen]) {
            [states insertObject:self.fullscreenDetails atIndex:0];
        }
        orderedStatesByPositionAscending = states;
    }
    return orderedStatesByPositionAscending;
}

- (BOOL)beforeDragWasDisplayedAsMenu
{
    return self.lastStableFloatViewState == FloatViewStateMenuFullscreen || self.lastStableFloatViewState == FloatViewStateMenuHalfscreen;
}

- (CGFloat)translatedFloat:(CGFloat)floatViewValue
{
    return [UIView pointAtScreenCoordinates:CGPointMake(0,floatViewValue) usedAtView:self.floatView.superview].y;
}

- (RCFloatViewState *)state:(NSInteger)state position:(CGFloat)positionAtThisState
{
    return [RCFloatViewState itemWithState:state positionAtThisState:positionAtThisState];
}

- (RCFloatViewState *)fullscreenMenu
{
    return [self state:FloatViewStateMenuFullscreen position:self.translatedFloatViewMinYForFullscreen];
}

- (RCFloatViewState *)halfscreenMenu
{
    return [self state:FloatViewStateMenuHalfscreen position:self.ranslatedFloatViewMenuYForHalfscreen];
}

- (RCFloatViewState *)hidden
{
    return [self state:FloatViewStateHidden  position:self.translatedFloatViewMaxYForHidden];
}

- (RCFloatViewState *)fullscreenDetails
{
    return [self state:FloatViewStateDetailsFullscreen position:self.translatedFloatViewMinYForFullscreen];
}

- (RCFloatViewState *)halfscreenDetails
{
    return [self state:FloatViewStateDetailsHalfscreen  position:self.translatedFloatViewDetailsYForHalfscreen];
}

- (CGFloat)translatedFloatViewMinYForFullscreen
{
    return [self translatedFloat:[self floatViewMinYForFullscreen]];
}

- (CGFloat) ranslatedFloatViewMenuYForHalfscreen
{
    return [self translatedFloat:[self floatViewMenuHalfDisplayedY]];
}

- (CGFloat)translatedFloatViewMaxYForHidden
{
    return [self translatedFloat:[self floatViewMaxYForHidden]];
}

- (CGFloat)translatedFloatViewDetailsYForHalfscreen
{
    return [self translatedFloat:[self floatViewDetailsHalfDisplayedY]];
}

@end
