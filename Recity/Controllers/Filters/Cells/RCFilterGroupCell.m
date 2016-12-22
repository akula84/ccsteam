//
//  RCFilterGroupCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterGroupCell.h"

@interface RCFilterGroupCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listMembersLabel;

@end

@implementation RCFilterGroupCell

- (void)updateWithModel:(RCFilterTableModel *)model
{
    [super updateWithModel:model];
    self.titleLabel.text = model.title;
    self.listMembersLabel.text = model.selectionDescription;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
