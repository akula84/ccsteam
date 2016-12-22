//
//  RCFavoriteTableManager.h
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoritableTableManager.h"

@interface RCFavoriteTableManager : RCFavoritableTableManager

@property (strong, nonatomic) dispatch_block_t didFavoritedProjectsListChangedBlock;

- (void)removeUnfavoritedProjects;

@end
