//
//  RCFilterDateSelectorCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterDateSelectorCell.h"

#import "DLRadioButton.h"

@interface RCFilterDateSelectorCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valuesLabel;
@property (weak, nonatomic) IBOutlet DLRadioButton *checkbox;

@property (nonatomic) NSUInteger yearMin;
@property (nonatomic) NSUInteger yearMax;

@end

@implementation RCFilterDateSelectorCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.checkbox.icon = IMG(@"checkbox_unchecked");
    self.checkbox.iconSelected = IMG(@"checkbox_checked");
    [self.checkbox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)updateWithModel:(RCFilterTableModel *)model
{
    [super updateWithModel:model];

    self.titleLabel.text = model.title;
    
    self.yearMin = (NSUInteger)model.currentMin.integerValue;
    self.yearMax = (NSUInteger)model.currentMax.integerValue;
    
    if (model.switchEnabled && !self.checkbox.selectedButtons.isFull) {
        [self.checkbox sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    [self updateValuesLabel];
}

- (IBAction)checkBoxAction:(DLRadioButton *)sender
{
    self.model.switchEnabled = sender.selectedButtons.isFull;
}

- (void)updateValuesLabel
{
    self.valuesLabel.text = [NSString stringWithFormat:@"%lu - %lu", (unsigned long)self.yearMin, (unsigned long)self.yearMax];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
