//
//  RCDevelopmentIndexOutlookGraph.m
//  Recity
//
//  Created by Vitaliy Zhukov on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexOutlookGraph.h"

@interface RCDevelopmentIndexOutlookGraph()

@property (strong, nonatomic) NSArray <NSNumber *> *graphPoints;

@property (strong, nonatomic) CAShapeLayer *animatedLayer;

@property (nonatomic) RCDIOutlookGraphType currentType;

@end

@implementation RCDevelopmentIndexOutlookGraph

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addBackgroundGrid];
}

- (void)addBackgroundGrid
{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = self.bounds;
    layer.contents = (id)IMG(@"graph_background").CGImage;
    [self.layer addSublayer:layer];
}

- (void)setGraphType:(RCDIOutlookGraphType)type
{
    NSArray *points = nil;
    self.currentType = type;
    switch (type) {
        case RCDIOutlookGraphTypeLow:
            points =  @[@1, @2, @2, @2, @2, @2, @2];
            break;
        case RCDIOutlookGraphTypeSteady:
            points =  @[@1, @2, @3, @5, @6, @7, @8];
            break;
        case RCDIOutlookGraphTypeVeryStrong:
            points =  @[@5, @6, @6, @7, @7, @7, @7];
            break;
        case RCDIOutlookGraphTypeStrongLongTerm:
            points =  @[@0, @1, @2, @3, @7, @7.5, @8];
            break;
        case RCDIOutlookGraphTypeStrongShortTerm:
            points =  @[@1, @4, @4.5, @5, @5, @6, @6];
            break;
        case RCDIOutlookGraphTypeModerateLongTerm:
            points =  @[@1.5, @2, @2, @3, @6, @6.5, @7];
            break;
        case RCDIOutlookGraphTypeModerateShortTerm:
            points =  @[@1, @4, @4.5, @4.5, @5, @5, @5];
            break;
    }
    self.graphPoints = points;
    [self removeGraphLine];
    [self addGraphLine];
    [self startAnimation];
}

- (NSString *)description
{
    NSString *description = @"";
    switch (self.currentType) {
        case RCDIOutlookGraphTypeLow:
            description = @"Low Development Activity";
            break;
        case RCDIOutlookGraphTypeSteady:
            description = @"Steady Development Activity";
            break;
        case RCDIOutlookGraphTypeVeryStrong:
            description = @"Very Strong Development Outlook";
            break;
        case RCDIOutlookGraphTypeStrongLongTerm:
            description = @"Strong Long Term Activity";
            break;
        case RCDIOutlookGraphTypeStrongShortTerm:
            description = @"Strong Short Term Activity";
            break;
        case RCDIOutlookGraphTypeModerateLongTerm:
            description = @"Moderate Long Term Activity";
            break;
        case RCDIOutlookGraphTypeModerateShortTerm:
            description = @"Moderate Short Term Activity";
            break;
    }
    
    return description;
}

- (void)addGraphLine
{
    CAShapeLayer *yellowArcLayer = [CAShapeLayer layer];
    
    yellowArcLayer.path = [[self graphLine] CGPath];
    yellowArcLayer.strokeColor = [RGB(244, 142, 41) CGColor];
    yellowArcLayer.fillColor = nil;
    yellowArcLayer.lineWidth = 4.0f;
    
    self.animatedLayer = yellowArcLayer;
}

- (void)removeGraphLine
{
    [self.animatedLayer removeFromSuperlayer];
}

- (UIBezierPath *)graphLine
{
    CGFloat xStep = CGRectGetWidth(self.bounds)/7.0f + 3.0f;
    CGFloat yStep = CGRectGetHeight(self.bounds)/7.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(0, (7.0f - [self.graphPoints firstObject].floatValue) * yStep);
    
    [path moveToPoint:startPoint];
    
    for (NSUInteger x = 1; x < self.graphPoints.count; x++) {
        
        NSNumber *y = self.graphPoints[x];
        
        CGPoint graphPoint = CGPointMake(x * xStep, (7.0f - y.floatValue) * yStep);
        
        [path addLineToPoint:graphPoint];
    }
    
    return path;
}

- (void)startAnimation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5f;
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(1.0f);
        [self.animatedLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        [self.layer addSublayer:self.animatedLayer];
    });
}

@end
