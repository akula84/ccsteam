//
//  BaseTableViewController.m
//  golf-fitness
//
//  Created by Matveev on 10.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RCBaseTableViewController.h"

@interface RCBaseTableViewController ()

@end

@implementation RCBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[];
    
    if (self.concretizedTitle) {
        self.title = self.concretizedTitle;
    }
    
    @weakify(self);
    self.tableManager.didSelectedCellWithItemBlock = ^(id item) {
        @strongify(self);
        RUN_BLOCK(self.didSelectedItemBlock, item);
    };

}

- (void)reloadData {
    //      you should rewrite it in subclasses
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_defaultSeparatorsZeroInset) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {//     http://stackoverflow.com/a/25764606/3627460
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - UITableViewDelegate DELEGATE

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!/*[self hasPendingRequests] && */self.items.count) {
        BOOL willDownloadNextPage = (scrollView.contentOffset.y + scrollView.height > scrollView.contentSize.height);
        if (willDownloadNextPage) {
            if (_needDownloadNextPageBecauseTableScrolledBlock) {
                _needDownloadNextPageBecauseTableScrolledBlock();
            }
        }
    }
}

@end
