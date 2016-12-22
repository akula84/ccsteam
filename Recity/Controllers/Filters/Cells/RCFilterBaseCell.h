//
//  RCFilterBaseCell.h
//  Recity
//
//  Created by Vitaliy Zhukov on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterTableModel.h"

@protocol RCFilterCellDelegate <NSObject>

- (void)cellValueChanged;

@end

@interface RCFilterBaseCell : UITableViewCell <RCFilterTableCell>

@property (strong, nonatomic) RCFilterTableModel *model;
@property (strong, nonatomic) id<RCFilterCellDelegate> delegate;

@end
