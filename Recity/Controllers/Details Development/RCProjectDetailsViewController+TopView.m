//
//  RCProjectDetailsViewController+TopView.m
//  Recity
//
//  Created by Artem Kulagin on 15.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"

#import "FavoriteHelper.h"
#import "RCProject.h"

@implementation RCProjectDetailsViewController (TopView)

- (void)prepareTopView
{
    RCProject *project = self.project;
    
    self.nameLabel.text = project.name;
    self.describingLabel.text = [[project extendedAddress] uppercaseString];

    [FavoriteHelper checkFavorite:project favoriteButton:self.favoriteButton];
}

@end
