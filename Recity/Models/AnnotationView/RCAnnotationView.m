//
//  RCAnnotationView.m
//  Recity
//
//  Created by Artem Kulagin on 20.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotationView.h"

@implementation RCAnnotationView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
   // NSLog(@"RCAnnotationView %@ %@",@(point.x),@(point.y));
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    NSLog(@"RCAnnotationView2 %@ %@    %@ %@",@(point.x),@(point.y),@(event.type),@(event.subtype));
    BOOL value = [super pointInside:point withEvent:event];
    NSLog(@"pointInside %@",@(value));
    return value;
}

- (void)addTempGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinAction)];
    //tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)pinAction
{
    NSLog(@"pinAction");
}

@end
