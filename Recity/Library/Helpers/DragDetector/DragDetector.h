//
//  DragDetector.h
//  ImageFilters
//
//  Created by Denis Matveev on 05/06/14.
//  Copyright (c) 2014 Denis Matveev. All rights reserved.
//

//!     @return     Will we try watch on drag action
typedef BOOL (^CanHandleDragWhenTouchDownAtLocationBlock)(CGPoint touchDownPoint);
//!     @return     Will we WATCH on drag action
typedef BOOL (^WillHandleDragWhenPanRecognizedAtLocationBlock)(CGPoint touchDownPoint, CGPoint panRecognizedAtPoint, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX);

typedef void (^DragBeganFromLocationBlock)(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint);
typedef void (^DragLocationChangedBlock)(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint);

@interface DragDetector : NSObject

@property (nonatomic, strong) CanHandleDragWhenTouchDownAtLocationBlock canHandleDragWhenTouchDownAtLocationBlock;
@property (nonatomic, strong) WillHandleDragWhenPanRecognizedAtLocationBlock willHandleDragWhenPanRecognizedAtLocationBlock;
@property (nonatomic, strong) DragBeganFromLocationBlock dragBeganFromLocationBlock;
@property (nonatomic, strong) DragLocationChangedBlock dragLocationChangedBlock;
@property (nonatomic, strong) dispatch_block_t dragFinishedAtLocationBlock;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign, readonly) BOOL dragInProgress;
@property (readonly, nonatomic, assign) BOOL isPanRecognizedOnLastRecognizedTouch;

- (id)initWithFundamentView:(UIView *)fundamentView;

@end
