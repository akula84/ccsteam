//
//  RecentViewCell.h
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCRecentSearch;

@interface RCSearchCell : UITableViewCell

+ (CGFloat)height;

@end

@interface RCSearchCell (Recent)

- (void)prepareTitleRecent;
- (void)prepareItemRecent:(RCRecentSearch *)item;

@end

@interface RCSearchCell (Result)

- (void)prepareResultTitle;
- (void)prepareResultItem:(id)item;

@end
