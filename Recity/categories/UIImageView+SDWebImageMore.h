//
//  UIImageView+_SDWebImageMore.h
//  golf-fitness
//
//  Created by Matveev on 25.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDWebImageOperation.h"

@interface UIImageView (SDWebImageMore)

- (id <SDWebImageOperation>)setImageWithURLstring:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage imageMissedView:(UIView *)imageMissedView;

@end
