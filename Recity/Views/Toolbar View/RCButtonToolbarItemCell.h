//
//  RCButtonToolbarItemCell.h
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarItemCell.h"

@interface RCButtonToolbarItemCell : RCToolbarItemCell

- (void)updateWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;
- (void)updateWithIndex;
- (void)updateWithNewIndex:(NSNumber *)index;

@end
