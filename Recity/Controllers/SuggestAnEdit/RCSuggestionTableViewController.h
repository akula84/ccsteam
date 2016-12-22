//
//  RCSuggestionTableViewCotroller.h
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCBaseNavigationController.h"

#import "RCSuggestionTableCell.h"

#import "RCSuggestionManager.h"

@interface RCSuggestionTableViewController : UIViewController

@property (strong, nonatomic) RCSuggestionManager *suggestionManager;

- (IBAction)back;
- (IBAction)close;

- (NSString *)cellReuseIdByIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(RCSuggestionTableCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;

@end
