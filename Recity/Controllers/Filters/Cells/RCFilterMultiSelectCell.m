//
//  RCFilterMultiSelectCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterMultiSelectCell.h"

#import "RCFilterTableModel.h"

@interface RCFilterMultiSelectCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImageView;

@end

@implementation RCFilterMultiSelectCell

- (void)updateWithModel:(RCFilterSelectorModel *)model
{
    self.titleLabel.text = model.title;
    
    UIImage *checkbox = nil;
    switch (model.checkboxState) {
        case RCFilterCheckboxStateChecked:
            checkbox = IMG(@"checkbox_checked");
            break;
        case RCFilterCheckboxStateUnchecked:
            checkbox = IMG(@"checkbox_unchecked");
            break;
        case RCFilterCheckboxPartial:
            checkbox = IMG(@"checkbox_partial");
            break;
    }
    
    self.checkboxImageView.image = checkbox;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
