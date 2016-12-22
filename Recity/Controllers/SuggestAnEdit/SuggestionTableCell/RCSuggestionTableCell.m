//
//  RCSuggestionTableCell.m
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionTableCell.h"

@interface RCSuggestionTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *nameItem;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation RCSuggestionTableCell

- (void)setModel:(RCSuggestionViewModel *)model
{
    self.imageItem.image = model.image;
    self.nameItem.text = model.text;
    
    if(model.suggestionAction == RCNewAction) {
        self.removeButton.hidden = NO;
    } else {
        self.removeButton.hidden = YES;
    }
    
    _model = model;
}

@end
