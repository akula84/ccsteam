//
//  Created by Denis Matveev on 18/02/16.
//

#import <Foundation/Foundation.h>

/**     @class Class for contain of keyboard info, such as frame, animation time, etc
     @warn Before first use you should prepare it. For example in didFinishLaunching:
     [[KeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
     [self.window makeKeyAndVisible];
*/
@interface KeyboardInfo : NSObject

+ (KeyboardInfo *)sharedInstance;

- (NSTimeInterval)keyboardAnimationTimeInterval;
- (CGFloat)keyboardHeight;
- (UIViewAnimationOptions)keyboardAnimationCurve;

- (BOOL)keyboardInfoGathered;

- (void)prepareKeyboardWithMainWindow:(UIWindow *)window;

@end
