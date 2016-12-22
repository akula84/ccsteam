//
//  RCBaseDevelopmentCell.h
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

@class RCInteractiveImageView;

@interface RCBaseDevelopmentCell : RCBaseSeparatedTableCell

@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet RCInteractiveImageView *rightInteractiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) id item;

- (void)setCommentButtonDisplayed:(BOOL)displayed;

@end
