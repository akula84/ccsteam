//
//  RecentView.h
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "BaseViewWithXIBInit.h"

@interface RCSearchParentView : BaseViewWithXIBInit

- (void)prepareItems:(NSArray *)array;

@end

@interface RCSearchParentView (Animate)

- (void)show;
- (void)remove;

- (void)startLoadAnimated;
- (void)loadFrameWithKeyBoard;

@end

