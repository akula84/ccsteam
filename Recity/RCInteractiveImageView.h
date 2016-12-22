//
//  TappableImageView.h
//  golf-fitness
//
//  Created by Matveev on 28/03/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCInteractiveImageView;

typedef void(^RCInteractiveImageViewBlock)(RCInteractiveImageView *imageView);

@interface RCInteractiveImageView : UIImageView

@property (strong, nonatomic) RCInteractiveImageViewBlock tappedBlock;

@end
