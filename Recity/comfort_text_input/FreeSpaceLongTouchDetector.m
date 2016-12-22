//
//  FreeSpaceLongTouchDetector.m
//  golf-fitness
//
//  Created by Matveev on 11.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "FreeSpaceLongTouchDetector.h"

@implementation FreeSpaceLongTouchDetector

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL result = ![[touch view] isKindOfClass:[UIControl class]] && ![[touch view] isKindOfClass:[UINavigationBar class]];
    //  Should not recognize gesture if the clicked view is either UIControl or UINavigationBar(<Back button etc...)
    return result;
}

@end
