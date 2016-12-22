//
//  DragDetector.h
//  ImageFilters
//
//  Created by Denis Matveev on 05/06/14.
//  Copyright (c) 2014 Denis Matveev. All rights reserved.
//

#import <Foundation/Foundation.h>

//!     @return     Will we try watch on drag action
typedef BOOL (^CanHandleDragWhenTouchDownAtLocationBlock)(CGPoint location);
//!     @return     Will we WATCH on drag action
typedef BOOL (^WillHandleDragWhenPanRecognizedAtLocationBlock)(CGPoint location, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX);

typedef void (^DragBeganFromLocationBlock)(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint);
typedef void (^DragLocationChangedBlock)(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint);
typedef void (^DragFinishedAtLocationBlock)(CGPoint location, CGPoint touchDownPoint);

@interface DragDetector : NSObject

@property (nonatomic, strong) CanHandleDragWhenTouchDownAtLocationBlock canHandleDragWhenTouchDownAtLocationBlock;
@property (nonatomic, strong) WillHandleDragWhenPanRecognizedAtLocationBlock willHandleDragWhenPanRecognizedAtLocationBlock;

@property (nonatomic, strong) DragBeganFromLocationBlock dragBeganFromLocationBlock;
@property (nonatomic, strong) DragLocationChangedBlock dragLocationChangedBlock;
@property (nonatomic, strong) DragFinishedAtLocationBlock dragFinishedAtLocationBlock;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign, readonly) BOOL dragInProgress;

- (id)initWithFundamentView:(UIView *)fundamentView;

@end
