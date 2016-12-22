//
//  LoaderView.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "LoaderView.h"

#import "FLAnimatedImage.h"

@interface LoaderView()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *labelLoadingProject;

@end

@implementation LoaderView

- (void)showLoadingProject
{
    self.labelLoadingProject.hidden = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadImage];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareLogin
{
    self.backgroundColor = [UIColor clearColor];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5f;
}

- (void)loadImage
{
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"spinner-loader" withExtension:@"gif"]]];
    self.imageView.animatedImage = image;
}

- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    } else {
        [super setHidden:hidden];
        self.alpha = 0.0f;
        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1.0f;
        } completion:nil];
    }
}

@end
