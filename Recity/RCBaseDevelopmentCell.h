//
//  RCBaseDevelopmentCell.h
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"
#import "RCProject.h"
#import "RCInteractiveImageView.h"

@interface RCBaseDevelopmentCell : RCBaseSeparatedTableCell

@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet RCInteractiveImageView *rightInteractiveImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) RCProject *project;

- (void)setCommentButtonDisplayed:(BOOL)displayed;

@end
