//
//  FavoriteHelper.m
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "FavoriteHelper.h"

@implementation FavoriteHelper

+ (void)checkFavorite:(id)item favoriteButton:(UIButton *)favoriteButton
{
    [self displayAsFavorited:[self isFavorited:item] favoriteButton:favoriteButton];
}

+ (void)favoriteAction:(id)item favoriteButton:(UIButton *)favoriteButton
{
    BOOL willFavorited = ![self isFavorited:item];
    [self displayAsFavorited:willFavorited favoriteButton:favoriteButton];
    [[self currentUser] setItem:item favoritedRemotely:willFavorited];
}

+ (void)displayAsFavorited:(BOOL)favorited favoriteButton:(UIButton *)favoriteButton
{
    NSString *name = favorited?@"favorite_orange_filled":@"star_white_empty_medium";
    UIImage *image = IMG(name);
    [favoriteButton setImage:image forState:UIControlStateNormal];
    [favoriteButton setImage:image forState:UIControlStateHighlighted];
}

+ (BOOL)isFavorited:(id)item
{
    return [[self currentUser] isItemFavoritedLocally:item];
}

+ (RCUser *)currentUser
{
    return [AppState sharedInstance].user;
}

@end
