//
//  RCItemViewControllerProtocol.h
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@protocol RCItemProtocol <NSObject>
@required

- (void)updateBindings;

@optional

- (void)scrollToTop;
- (void)prepareData;

@end
