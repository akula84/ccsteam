//
//  RCProjectDetailsCell.m
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsCell.h"

#import "UIFont+RecityFont.h"
#import "RCProjectDetail.h"

static CGFloat betweenWidth =  96.f;
static CGFloat betweenHeight =  23.f;

@interface RCProjectDetailsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;

@end

@implementation RCProjectDetailsCell

- (void)setDetail:(RCProjectDetail *)detail
{
    self.leftImageView.image = detail.image;
    self.nameLabel.text = detail.title;
    self.describingLabel.text = detail.describing;
}

+ (CGFloat)height:(RCProjectDetail *)detail
{
    UIFont *nameFont = [UIFont flamaBasic:9.f];
    UIFont *describingFont = [UIFont flamaBook13];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - betweenWidth - kCellInsets;
    CGFloat nameHeight = [detail.title  heightWithFont:nameFont width:width];
    CGFloat describingHeight = [detail.describing  heightWithFont:describingFont width:width];
    return nameHeight + describingHeight + betweenHeight;
}

@end
