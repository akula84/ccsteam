//
//  RCDevelopmentIndexViewController+TableView.m
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexViewController_Private.h"

#import "RCDevelopmentIndexMetricModel.h"
#import "RCAddress.h"

@implementation RCDevelopmentIndexViewController (TableView)

- (void)setupTableObserver:(BOOL)enabled
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if (enabled) {
        [center addObserver:self selector:@selector(reloadCellFromNotification:) name:kNotificationMetricsCellNeedReload object:nil];
        [center addObserver:self selector:@selector(updateMetrics) name:kNotificationProjectsLoaded object:nil];
    } else {
        [center removeObserver:self];
    }
}

- (void)updateMetrics
{
    [self.address reloadMetrics];
    [self.tableView reloadData];
}

- (void)reloadCellFromNotification:(NSNotification *)notification
{
    RCDevelopmentIndexMetricModel *modelObject = (RCDevelopmentIndexMetricModel *)notification.object;
    
    NSUInteger row = [self.model indexOfObject:modelObject];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppState advancedVersion] ? (NSInteger)self.model.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 82.0f;
    RCDevelopmentIndexMetricModel *model = [self itemAtIndexPath:indexPath];
    if (model.opened) {
        height += [model heightForView];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCDevelopmentIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diMetricsCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(RCDevelopmentIndexTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell updateWithModel:[self itemAtIndexPath:indexPath]];
    cell.delegate = self;
}

- (void)stateChangeNeededForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (self.currentOpenedIndexPath && self.currentOpenedIndexPath.row != indexPath.row) {
        RCDevelopmentIndexMetricModel *openedModel = [self itemAtIndexPath:self.currentOpenedIndexPath];
        openedModel.opened = NO;
        [arr addObject:self.currentOpenedIndexPath];
    }
    
    RCDevelopmentIndexMetricModel *model = [self itemAtIndexPath:indexPath];
    model.opened = !model.opened;
    [arr addObject:indexPath];
    
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
    self.currentOpenedIndexPath = indexPath;
    
    if (indexPath.row > 0) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    [self sendAnalyticsForMetric:model];
}

- (RCDevelopmentIndexMetricModel *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.model[(NSUInteger)indexPath.row];
}

- (NSArray <RCDevelopmentIndexMetricModel *> *)model
{
    return [self.address metricsModel];
}

- (void)sendAnalyticsForMetric:(RCDevelopmentIndexMetricModel *)model
{
    if(model.opened) {
        [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:RCDevelopmentIndexCategory
                                                                       action:RCDevelopmentIndexMetricAction
                                                                        label:model.title
                                                                        value:nil];
    }
}

@end
