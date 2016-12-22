//
//  RCMapToolbarView+Controller.h
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapToolbarView.h"
#import "RCToolbarView_Protected.h"

@interface RCMapToolbarView()

- (void)switchToolbarToState:(RCMapToolbarViewState)state;

@end

@interface RCMapToolbarView (Controller)

- (void)prepareToolbarController;

@end

@interface RCMapToolbarView (Action)

- (void)didToolbarViewItemSelected:(NSInteger)toolbarViewItemIndex selectedItemPressed:(BOOL)selectedItemPressed;

@end
