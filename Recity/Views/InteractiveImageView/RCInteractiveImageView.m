//
//  TappableImageView.m
//  golf-fitness
//
//  Created by Matveev on 28/03/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RCInteractiveImageView.h"

#import "RCTapDetector.h"

@interface RCInteractiveImageView ()

@property (strong, nonatomic) RCTapDetector *tapDetector;

@end

@implementation RCInteractiveImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.userInteractionEnabled = YES;
    
    self.tapDetector = [[RCTapDetector alloc] init];
    @weakify(self);
    self.tapDetector.didTappedBlock = ^() {
        @strongify(self);
        RUN_BLOCK(self.tappedBlock, self);
    };
    [self.tapDetector attachToTargetView:self];
}

@end
