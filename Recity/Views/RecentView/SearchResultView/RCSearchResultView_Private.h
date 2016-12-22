//
//  RCSearchResultView+LoadingView.h
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchResultView.h"

#import "RCSearchCell.h"

@class LoaderView;

@interface RCSearchResultView()

@property (strong, nonatomic) LoaderView *loaderView;

@end

@interface RCSearchResultView (LoadingView)

- (void)addLoadingView;
- (void)loadinViewHidden:(BOOL)hidden;

@end
