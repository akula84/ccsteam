//
//  RCFloatViewSlider+Controller.h
//  Recity
//
//  Created by Artem Kulagin on 07.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSlider.h"

@class DragDetector;

@class RCMainTablesScrollView;

@interface RCFloatViewSlider ()

@property (weak, nonatomic) IBOutlet RCMainTablesScrollView *scrollView;
@property (strong, nonatomic) DragDetector *dragDetector;

@property (assign, nonatomic) FloatViewState lastStableFloatViewState;
@property (assign, nonatomic, readwrite) BOOL isScrollViewMoved;

- (BOOL)isPanRecognizedOnLastRecognizedTouch;
- (BOOL)canOpenFullscreen;
- (CGFloat)maximumFreeHeight;
- (CGFloat)floatViewFullDisplayedY;
- (CGFloat)floatViewMinYForFullscreen;
- (CGFloat)floatViewMaxYForHidden;
- (CGFloat)floatViewMenuHalfDisplayedY;
- (CGFloat)floatViewDetailsHalfDisplayedY;
- (BOOL)canOpenHalfscreen;
- (void)displayFloatViewInState:(FloatViewState)state animated:(BOOL)animated timeInterval:(NSNumber *)timeInterval completion:(dispatch_block_t)completion;

@end

@interface RCFloatViewSlider (Controller)

- (void)prepareController;

@end

@interface RCFloatViewSlider (DragDetector)

- (void)addDragDetector;

@end
