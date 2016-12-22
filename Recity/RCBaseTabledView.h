//
//  RCBaseTabledView.h
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCBaseTableCell.h"

@interface RCBaseTabledView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *sectionHeaderViewSample;
@property (strong, nonatomic) RCBaseTableCell *cellSample;
@property (strong, nonatomic) UIView *sectionFooterViewSample;
@property (strong, nonatomic) NSArray *items;

@property (assign, nonatomic) BOOL useSeparatorsZeroInset;

@end
