//
//  RCDevelopmentIndexTableViewCell.h
//  Recity
//
//  Created by Vitaliy Zhukov on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCDevelopmentIndexMetricModel;

@protocol RCDevelopmentIndexTableViewCellDelegate <NSObject>

@required
- (void)stateChangeNeededForCell:(UITableViewCell *)cell;

@end

@interface RCDevelopmentIndexTableViewCell : UITableViewCell

@property (weak, nonatomic) id <RCDevelopmentIndexTableViewCellDelegate> delegate;

- (void)updateWithModel:(RCDevelopmentIndexMetricModel *)model;

@end
