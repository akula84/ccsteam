//
//  SharePopupView.h
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "ClosablePopupView.h"

@interface SharePopupView : ClosablePopupView

@property (copy, nonatomic) void(^didCloseAction)();

@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@end
