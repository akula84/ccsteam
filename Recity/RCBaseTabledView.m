//
//  RCBaseTabledView.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTabledView.h"

@implementation RCBaseTabledView

//      this and next method for dispaying of default table separators with UIEdgeInsetsZero
- (void)setUseSeparatorsZeroInset:(BOOL)useSeparatorsZeroInset {
    _useSeparatorsZeroInset = useSeparatorsZeroInset;
    if (_useSeparatorsZeroInset) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.useSeparatorsZeroInset) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {//     http://stackoverflow.com/a/25764606/3627460
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSample.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //      you SHOULD rewrite this method in subclasses
    UITableViewCell *result = [UITableViewCell new];
    return result;
}

@end
