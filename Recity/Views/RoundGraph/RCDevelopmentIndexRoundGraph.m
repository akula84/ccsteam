//
//  RCDevelopmentIndexRoundGraph.m
//  Recity
//
//  Created by Vitaliy Zhukov on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexRoundGraph.h"
#import "UICountingLabel.h"

@interface RCDevelopmentIndexRoundGraph()

@property (nonatomic) CGFloat index;
@property (strong, nonatomic) CAShapeLayer *animatedLayer;

@end

@implementation RCDevelopmentIndexRoundGraph

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupLayer];
}

- (void)setupLayer
{
    CAShapeLayer *whiteArcLayer = [CAShapeLayer layer];
    
    whiteArcLayer.path = [[self arc] CGPath];
    whiteArcLayer.strokeColor = [[UIColor whiteColor] CGColor];
    whiteArcLayer.fillColor = nil;
    whiteArcLayer.lineWidth = 1.0f;
    
    [self.layer addSublayer:whiteArcLayer];
    
    CAShapeLayer *yellowArcLayer = [CAShapeLayer layer];
    
    yellowArcLayer.path = [[self arc] CGPath];
    yellowArcLayer.strokeColor = [RGB(244, 142, 41) CGColor];
    yellowArcLayer.fillColor = nil;
    yellowArcLayer.lineWidth = 4.0f;
    yellowArcLayer.strokeEnd = self.index;
    
    self.animatedLayer = yellowArcLayer;
}

- (UIBezierPath *)arc
{
    CGFloat radius = CGRectGetWidth(self.bounds)/2.0f - 5.f;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), radius + 5.f);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:(CGFloat)M_PI - 0.4f
                                                      endAngle:0.4f
                                                     clockwise:YES];
    
    return path;
}

@synthesize index = _index;

- (void)setIndex:(CGFloat)index
        animated:(BOOL)animated
{
    if (index > 0) {
        _index = index / 100.0f;
        
        [self.animatedLayer removeFromSuperlayer];
        
        if (animated) {
            [self startAnimationToIndex:self->_index];
            self.animatedLayer.strokeEnd = self->_index;
        } else {
            [self indexLabel].text = [NSString stringWithFormat:@"%.0f", self.index];
            self.animatedLayer.strokeEnd = self->_index;
        }
        
        [self.layer addSublayer:self.animatedLayer];
    } else {
        [self indexLabel].text = @"--";
    }
}

- (CGFloat)index
{
    return _index * 100.0f;
}

- (UICountingLabel *)indexLabel
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UICountingLabel class]]) {
            return (UICountingLabel *)view;
        }
    }
    return nil;
}

- (void)startAnimationToIndex:(CGFloat)index
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5f;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(index);
    [self.animatedLayer addAnimation:pathAnimation
                              forKey:@"strokeEnd"];
    
    UICountingLabel *indexLabel = [self indexLabel];
    indexLabel.method = UILabelCountingMethodEaseOut;
    indexLabel.format = @"%.0f";
    indexLabel.animationDuration = 0.5f;
    [indexLabel countFrom:0.f
                       to:self.index];
}

@end
