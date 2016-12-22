//
//  RCDevelopmentIndexCell.m
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexCell.h"

#import "RCProjectDetail.h"

@interface RCDevelopmentIndexCell ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation RCDevelopmentIndexCell

- (void)setDetail:(RCProjectDetail *)detail
{
    _detail = detail;
    
    self.indexLabel.text = detail.title;
    self.rightButton.userInteractionEnabled = NO;
}

@end
