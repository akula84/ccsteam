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

//      placeholderView will used when placeholderImage is nil
//      imageMissedView should be placed under this UIImageView for do available of self's UIImageView interaction
//      strange case: image cashed yet. then restart app. run this method. so block inside it will called twice. first time for cached image. and second time when image downloaded. So we needed to check this image not same, if so, then display it animated, else do nothing. But checking of same so heaviy by performance. How to avoid it?
- (id <SDWebImageOperation>)setImageWithURLstring:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage imageMissedView:(UIView *)imageMissedView {
    id <SDWebImageOperation> result;
    __typeof__(self) __weak wself = self;
    wself.hidden = NO;
    wself.image = nil;
    if (placeholderImage) {
        wself.alpha = 1.0;
        wself.image = placeholderImage;
    } else {
        wself.alpha = 0.0;
    }
    imageMissedView.alpha = 0.0;
    imageMissedView.hidden = NO;
    if (urlString) {
        result = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (cacheType == SDImageCacheTypeNone) {//      downloaded now
                if (image && !error) {
                    [UIView transitionWithView:self duration:kAnimationTimeInterval options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.image = image;
                        wself.alpha = 1.0;
                    } completion:nil];
                } else {//      empty image or error
                    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
                        imageMissedView.alpha = 1.0;
                    } completion:nil];
                }
            } else {//      cached in SDImageCacheTypeDisk or SDImageCacheTypeMemory
                    self.image = image;
                    wself.alpha = 1.0;
                //      some other actions when cached image exists
            }
        }];
    } else {
        [UIView animateWithDuration:kAnimationTimeInterval animations:^{
            imageMissedView.alpha = 1.0;
            wself.alpha = 0.0;
            //      some other actions when good image exists
        } completion:nil];
    }
    return result;
}

@end
