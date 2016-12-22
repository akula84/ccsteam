//
//  RCMapViewController+NavTitle.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCAddress.h"
#import "RCProject.h"

@implementation RCMapViewController (NavTitle)

- (void)prepareClearTitle
{
    [self prepareTitleText:@""];
}

- (void)prepareDefaultTitle
{
    [self prepareTitleText:defaultBarTitle];
}

- (void)prepareTitleFromItem:(id)item
{
    NSString *title;
    if ([item isKindOfClass:[RCProject class]]) {
        title  = ((RCProject *)item).name;
    } else if ([item isKindOfClass:[RCAddress class]]) {
        title  = ((RCAddress *)item).address;
    }
    [self prepareTitleText:title];
}

- (void)prepareTitleText:(NSString *)text
{
    self.title = text;
}

@end
