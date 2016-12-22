//
//  RCButtonToolbarItemCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCButtonToolbarItemCell.h"

#import "RCToolbarController.h"

@interface RCButtonToolbarItemCell ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@end

@implementation RCButtonToolbarItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerNotifications:YES];
}

- (void)updateWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self.image = image;
    self.selectedImage = selectedImage;
    self.pictureImageView.hidden = NO;
    self.indexLabel.hidden = YES;
    self.selected = self.selected;
}

- (void)prepareForReuse
{
    [self setDisabled:NO];
}

- (void)updateWithIndex
{
    self.pictureImageView.hidden = YES;
    self.indexLabel.hidden = NO;
    NSNumber *developmentIndex = [RCToolbarController shared].currentDevelopmentIndex;
    if(developmentIndex) {
        self.indexLabel.text = developmentIndex.stringValue;
    } else {
        self.indexLabel.textColor = kDisabledButtonPurpleColor;
        self.indexLabel.text = @"--";
    }
    self.selected = self.selected;
}

- (void)dealloc
{
    [self registerNotifications:NO];
}

- (void)registerNotifications:(BOOL)enable
{
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromNotification:)
                                                     name:kNotificationCurrentDevelopmentIndexUpdated
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)updateFromNotification:(NSNotification *)notification
{
    NSNumber *index = (NSNumber *)notification.object;
    
    [self updateWithNewIndex:index];
}

- (void)updateWithNewIndex:(NSNumber *)index
{
    if (index) {
        [self setDisabled:NO];
        self.indexLabel.text = index.stringValue;
    } else {
        [self setDisabled:YES];
    }
}

/*
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.pictureImageView.image = self.selectedImage;
        self.backgroundColor = kDarkPurpleColor;
        self.indexLabel.textColor = kMediumOrangeColor;
    } else {
        self.pictureImageView.image = self.image;
        self.backgroundColor = [UIColor whiteColor];
        self.indexLabel.textColor = kDarkPurpleColor;
    }
}
*/
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
    if (!self.disabled) {
        self.pictureImageView.image = self.selectedImage;
        self.backgroundColor = kDarkPurpleColor;
        self.indexLabel.textColor = kMediumOrangeColor;
    }
}

- (void)turnIntoNormalState {
    self.pictureImageView.image = self.image;
    self.backgroundColor = [UIColor whiteColor];
    self.indexLabel.textColor = kDarkPurpleColor;
}

- (void)setDisabled:(BOOL)disabled {
    [super setDisabled:disabled];
    
    self.userInteractionEnabled = !disabled;
    
    if (disabled) {
        [self setSelected:NO];
        self.pictureImageView.image = [Utils image:self.image maskedByColor:kDisabledButtonPurpleColor];
        self.indexLabel.textColor = kDisabledButtonPurpleColor;
        self.indexLabel.text = @"--";
    } else {
        self.pictureImageView.image = self.image;
        self.selected = self.selected;
    }
}

@end
