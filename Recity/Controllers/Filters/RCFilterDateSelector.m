//
//  RCFilterDateSelector.m
//  Recity
//
//  Created by Vitaliy Zhukov on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterDateSelector.h"

#import "RCFilterDateSelectorDateCell.h"

@implementation RCFilterDateSelector

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCFilterDateSelectorDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.values[(NSUInteger)indexPath.row].stringValue;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.values.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) {
            self.completionBlock(self.values[(NSUInteger)indexPath.row]);
        }
    }];
}

@end
