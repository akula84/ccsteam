//
//  RCSearchManager+Delegate.m
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchManager.h"
#import "RCSearchManager_Private.h"

@implementation RCSearchManager (Delegate)

- (void)didRecentText:(NSString *)text
{
    id<RCSearchManagerDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(searchManager:didRecentText:)]){
        [delegate searchManager:self didRecentText:text];
    }
}

- (void)didResultItem:(id)item
{
    self.resultItem = item;
    [self addRecent:self.searchText];
    id<RCSearchManagerDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(searchManager:showItem:)]){
        [delegate searchManager:self showItem:item];
    }
}

@end
