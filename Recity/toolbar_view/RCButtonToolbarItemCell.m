//
//  RCButtonToolbarItemCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCButtonToolbarItemCell.h"

@interface RCButtonToolbarItemCell ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@end

@implementation RCButtonToolbarItemCell

- (void)updateWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self.image = image;
    self.selectedImage = selectedImage;
    self.selected = self.selected;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.pictureImageView.image = self.selectedImage;
        self.backgroundColor = kDarkPurpleColor;
    } else {
        self.pictureImageView.image = self.image;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        if (self.autodeselectionEnabled) {
            [self turnIntoNormalState];
        } else {
            [self turnIntoSelectedState];
        }
    } else {
        [self turnIntoNormalState];
    }
}

- (void)turnIntoSelectedState {
    self.pictureImageView.image = self.selectedImage;
    self.backgroundColor = kDarkPurpleColor;
}

- (void)turnIntoNormalState {
    self.pictureImageView.image = self.image;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setDisabled:(BOOL)disabled {
    [super setDisabled:disabled];
    
    if (disabled) {
        self.pictureImageView.image = [Utils image:self.pictureImageView.image maskedByColor:kDisabledButtonPurpleColor];
    } else {
        self.pictureImageView.image = self.image;
    }
}

@end
