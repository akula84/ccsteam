//
//  RCProjectDetailsCell.m
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsCell.h"

@interface RCProjectDetailsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;

@end

@implementation RCProjectDetailsCell

- (void)setDetail:(RCProjectDetail *)detail {
    self.leftImageView.image = detail.image;
    self.nameLabel.text = detail.title;
    self.describingLabel.text = detail.describing;
}

@end
