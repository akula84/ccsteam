//
//  RCBaseDevelopmentCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseDevelopmentCell.h"

#import "RCAddress.h"
#import "RCProject.h"
#import "RCInteractiveImageView.h"

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

- (void)setItem:(id)item
{
    _item = item;
    
    NSString *name;
    NSString *address;
    BOOL nowFavorited = NO;
    if ([item isKindOfClass:[RCProject class]]) {
        RCProject *project = (RCProject *)self.item;
        name = project.name;
        address =[project extendedAddress];
    }
    if ([item isKindOfClass:[RCAddress class]]) {
        RCAddress *locationAddress = (RCAddress *)self.item;
        name = locationAddress.address;
        address = @"";
     }
    
    nowFavorited = [self isItemFavoritedLocally:item];
    self.nameLabel.text = name;
    self.addressLabel.text = address;
    [self setCommentButtonDisplayed:NO];
    [self displayAsFavorited:nowFavorited];
    
}

- (BOOL)isItemFavoritedLocally:(id)item
{
    return [[self currentUser] isItemFavoritedLocally:item];
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
        self.rightInteractiveImageView.image = IMG(@"favorite_star");
    }
}

- (RCUser *)currentUser
{
    return [AppState sharedInstance].user;
}

- (void)favoriteAction
{
    BOOL nowFavorited = [self isItemFavoritedLocally:self.item];
    BOOL willFavorited = !nowFavorited;
    [[self currentUser] setItem:self.item favoritedRemotely:willFavorited];
 }

@end
