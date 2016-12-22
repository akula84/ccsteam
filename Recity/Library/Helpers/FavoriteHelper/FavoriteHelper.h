//
//  FavoriteHelper.h
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface FavoriteHelper : NSObject

+ (void)favoriteAction:(id)item favoriteButton:(UIButton *)favoriteButton;
+ (void)checkFavorite:(id)item favoriteButton:(UIButton *)favoriteButton;

@end
