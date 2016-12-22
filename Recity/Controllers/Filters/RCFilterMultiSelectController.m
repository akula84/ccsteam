//
//  RCFilterMultiSelectController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterMultiSelectController.h"

#import "RCFilterMultiSelectCell.h"
#import "RCFilterEnablerCell.h"

@interface RCFilterMultiSelectController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RCFilterMultiSelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.titleLabel.text = self.model.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[RCFilterTableModel class]]) {
        RCFilterTableModel *model = item;
        
        RCFilterEnablerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"additionsSwitcher" forIndexPath:indexPath];
        
        [cell updateWithModel:model];
        
        return cell;
        
    } else {
        RCFilterSelectorModel *model = item;
        
        NSString *cellID = model.parent ? @"additionOptionCell" : @"mainOptionCell";
        
        RCFilterMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        [cell updateWithModel:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id item = [self itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[RCFilterSelectorModel class]]) {
        RCFilterSelectorModel *model = [self itemAtIndexPath:indexPath];
        [model switchState];
        [tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.model.values.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model.values[(NSUInteger)indexPath.row];
}

@end
