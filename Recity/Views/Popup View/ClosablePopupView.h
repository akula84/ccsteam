//
//  ClosablePopupView.h
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "PopupView.h"

@interface ClosablePopupView : PopupView

- (void)setupHeaderText:(NSString *)headerText
               mainText:(NSString *)mainText
           okButtonText:(NSString *)okButtonText;

@end
