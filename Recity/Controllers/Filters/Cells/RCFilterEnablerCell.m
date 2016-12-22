//
//  RCFilterEnablerCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterEnablerCell.h"

@interface RCFilterEnablerCell()

@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end

@implementation RCFilterEnablerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.switcher.transform = CGAffineTransformMakeScale(0.58f, 0.58f);
}

- (void)updateWithModel:(RCFilterTableModel *)model
{
    [super updateWithModel:model];
    
    self.switcher.on = model.switchEnabled;
}
- (IBAction)swtchAction:(id)sender
{
    self.model.switchEnabled = self.switcher.on;
    [self.delegate cellValueChanged];
}

@end
