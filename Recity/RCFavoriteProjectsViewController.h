//
//  RCFavoriteProjectsViewController.h
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableViewController.h"

@interface RCFavoriteProjectsViewController : RCBaseTableViewController

@property (strong, nonatomic) dispatch_block_t didFavoritedProjectsListChangedBlock;

- (void)removeUnfavoritedProjects;

@end
