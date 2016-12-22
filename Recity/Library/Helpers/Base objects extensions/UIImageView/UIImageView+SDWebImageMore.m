//
//  UIImageView+_SDWebImageMore.m
//  golf-fitness
//
//  Created by Matveev on 25.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "UIImageView+SDWebImageMore.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define kAnimationTimeInterval 0.5

@implementation UIImageView (SDWebImageMore)

- (id <SDWebImageOperation>)setImageWithURLstring:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage imageMissedView:(UIView *)imageMissedView completion:(dispatch_block_t)completion {
    id <SDWebImageOperation> result;
    self.hidden = NO;
    self.image = nil;
    if (placeholderImage) {
        self.alpha = 1.0;
        self.image = placeholderImage;
    } else {
        self.alpha = 0.0;
    }
    imageMissedView.alpha = 0.0;
    imageMissedView.hidden = NO;
    if (urlString) {
        
        @weakify(self);
        result = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (cacheType == SDImageCacheTypeNone) {
                if (image && !error) {
                    [UIView transitionWithView:self duration:kAnimationTimeInterval options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.image = image;
                        self.alpha = 1.0;
                    } completion:nil];
                } else {
                    self.image = nil;
                    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
                        imageMissedView.alpha = 1.0;
                    } completion:nil];
                }
            } else {
                    self.image = image;
                    self.alpha = 1.0;
            }
            RUN_BLOCK(completion);
        }];
    } else {
        [UIView animateWithDuration:kAnimationTimeInterval animations:^{
            imageMissedView.alpha = 1.0;
            self.alpha = 0.0;
        } completion:nil];
        RUN_BLOCK(completion);
    }
    return result;
}

- (id <SDWebImageOperation>)setImageWithURLstring:(NSString *)urlString placeholderNOImage:(UIImage *)placeholderImage viewFailed:(UIView *)viewFailed completion:(dispatch_block_t)completion
{
    id <SDWebImageOperation> result;
    self.hidden = NO;
    self.image = nil;
    viewFailed.hidden =  YES;

    if (urlString) {
        @weakify(self);
        result = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (cacheType == SDImageCacheTypeNone) {
                if (image && !error) {
                    [UIView transitionWithView:self duration:kAnimationTimeInterval options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.image = image;
                        self.alpha = 1.0;
                    } completion:nil];
                } else {
                    self.image = nil;
                    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
                        viewFailed.alpha = 1.0;
                        viewFailed.hidden = NO;
                    } completion:nil];
                }
            } else {
                self.image = image;
                self.alpha = 1.0;
            }
            RUN_BLOCK(completion);
        }];
    } else {
        self.image  = placeholderImage;

        RUN_BLOCK(completion);
    }
    return result;
}

@end
