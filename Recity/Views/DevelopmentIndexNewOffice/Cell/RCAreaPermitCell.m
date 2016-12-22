//
//  RCAreaPermitCell.m
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAreaPermitCell.h"

static CGFloat const heightGraph = 73.f;

@interface RCAreaPermitCell()

@property (nonatomic) IBInspectable BOOL showLeftTitle;
@property (nonatomic) IBInspectable NSString *title;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upDotConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downDotConstrains;
@property (strong, nonatomic) NSNumber *percent;

@end

@implementation RCAreaPermitCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = [NSString stringWithFormat:@"%@\nYEARS AGO",self.title];
    self.leftMessage.hidden = !self.showLeftTitle;
}

- (void)setPercent:(NSNumber *)percent maxValue:(NSNumber *)maxValue
{
    _percent = percent;
    [self prepatePercentLabel];
    
    self.upConstrains.constant = 0.f;
    self.downConstrains.constant = 0.f;
    CGFloat percentFloat = [self percentFloat];
    NSLayoutConstraint *constrains;
    constrains = (percentFloat > 0)?self.upConstrains:self.downConstrains;
    constrains.constant  = ABS((percentFloat * heightGraph)/maxValue.floatValue);
}

- (void)prepatePercentLabel
{
    CGFloat percentFloat = [self percentFloat];
    NSString *prefix = (percentFloat > 0)?@"+":@"";
    self.percentLabel.text = [NSString stringWithFormat:@"%@%@%@",prefix,@(percentFloat),@"%"];
}

- (CGFloat)percentFloat
{
    return self.percent.floatValue;
}

- (void)hideUp
{
    self.upDotConstrains.constant = 0.f;
}

- (void)hideDown
{
    self.downDotConstrains.constant = 0.f;
}

@end
