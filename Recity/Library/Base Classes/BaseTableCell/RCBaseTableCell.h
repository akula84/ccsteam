//
//  BaseTableCell.h
//  golf-fitness
//
//  Created by Matveev on 04.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

@interface RCBaseTableCell : UITableViewCell

@property (assign, nonatomic) UIEdgeInsets contentViewInsets;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

+ (void)setDefaultSelectionColor:(UIColor *)color;//       do it on start of application :)

//      if nil separator willn't displayed
- (void)displaySeparatorsWithColor:(UIColor *)color topSeparatorHeight:(NSNumber *)topSeparatorHeight bottomSeparatorHeight:(NSNumber *)bottomSeparatorHeight displayWhenSelected:(BOOL)displayWhenSelected;

@end
