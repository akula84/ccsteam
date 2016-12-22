//
//  BaseTableViewController.h
//  golf-fitness
//
//  Created by Matveev on 10.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RCBaseViewController.h"
#import "RCTableManager.h"


@interface RCBaseTableViewController : RCBaseViewController

@property (strong, nonatomic) IBOutlet RCTableManager *tableManager;

@property (strong, nonatomic) UIView *sectionHeaderViewSample;
@property (strong, nonatomic) BaseTableCell *cellSample;
@property (strong, nonatomic) UIView *sectionFooterViewSample;
@property (strong, nonatomic) NSArray *items;

@property (nonatomic) BOOL defaultSeparatorsZeroInset;

@property (strong, nonatomic) dispatch_block_t needDownloadNextPageBecauseTableScrolledBlock;

@property (copy, nonatomic) RCTableItemBlock didSelectedItemBlock;

- (void)reloadData;

@end
