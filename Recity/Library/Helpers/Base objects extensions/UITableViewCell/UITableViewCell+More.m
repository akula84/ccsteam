/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "UITableViewCell+More.h"
#import "NSObject+ClassName.h"
#import "UIView+More.h"

@implementation UITableViewCell (More)

+ (id)createForTable:(UITableView*)table {
    UITableViewCell* result = [table dequeueReusableCellWithIdentifier:[self rc_className]];
    if (!result) {
        result = [self createTableViewCell];
    }
    return result;
}

+ (id)createTableViewCell {
	NSString *nibName = [self rc_className];
 	return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
}

- (CGFloat)contentHeightForTableView:(UITableView *)tableView {
	self.width = tableView.width;
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
	
	CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	
	return size.height + (tableView.separatorStyle == UITableViewCellSeparatorStyleNone ? 0.0f : 1.0f);
}

@end
