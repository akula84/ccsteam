//
//  RCBaseDevelopmentCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseDevelopmentCell.h"

@interface RCBaseDevelopmentCell ()

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonWidthConstraint;
@property (assign, nonatomic) CGFloat startCommentButtonWidth;

@end

@implementation RCBaseDevelopmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.startCommentButtonWidth = self.commentButtonWidthConstraint.constant;
    
    @weakify(self);
    self.rightInteractiveImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    };
    self.rightInteractiveImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        @strongify(self);
        [self favoriteAction];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)setProject:(RCProject *)project {
    _project = project;
    self.nameLabel.text = self.project.name;
    self.addressLabel.text = self.project.address;
    
    [self setCommentButtonDisplayed:NO];
    
    RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
    RCProject *localProject = [[RCProject rc_objectsWithUIDs:@[self.project.uid] inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
    BOOL nowFavorited = [localUser isProjectFavoritedLocally:localProject];
    [self displayAsFavorited:nowFavorited];

//    BOOL commentExists = development.comment && development.comment.length;
//    if (!commentExists) {
//        self.commentButtonWidthConstraint.constant = 0;
//    } else {
//        self.commentButtonWidthConstraint.constant = self.startCommentButtonWidth;
//    }
}

- (void)setCommentButtonDisplayed:(BOOL)displayed {
    if (displayed) {
        self.commentButtonWidthConstraint.constant = self.startCommentButtonWidth;
    } else {
        self.commentButtonWidthConstraint.constant = 0;
    }
}

- (void)displayAsFavorited:(BOOL)favorited {
    if (favorited) {
        self.rightInteractiveImageView.image = IMG(@"favorite_orange_filled");
    } else {
        self.rightInteractiveImageView.image = IMG(@"favorite_blue");
    }
}

- (void)favoriteAction {
    RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
    RCProject *localProject = [[RCProject rc_objectsWithUIDs:@[self.project.uid] inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
    BOOL nowFavorited = [localUser isProjectFavoritedLocally:localProject];
    BOOL willFavorited = !nowFavorited;
    [localUser setProject:localProject favoritedRemotely:willFavorited].finally(^{

    });
    NSLog(@"willMakeFavorite %@",@(willFavorited));
}

@end
