//
//  PopupView.h
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface PopupView : UIView

+ (instancetype)loadNib;

- (void)displayOnView:(UIView *)fundamentView;
- (void)hideAnimated;

@end
