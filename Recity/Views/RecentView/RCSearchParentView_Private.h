//
//  RecentView+TableView.h
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchParentView.h"

@interface RCSearchParentView()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) BOOL isFirstRun;

- (void)loadItems;
- (NSString *)reuseID;

@end

@interface RCSearchParentView (TableView)<UITableViewDelegate,UITableViewDataSource>

@end

@interface RCSearchParentView (KVO)

- (void)addObserverKeyboard;

@end
