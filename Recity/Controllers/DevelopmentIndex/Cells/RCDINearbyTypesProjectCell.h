//
//  RCDINearbyTypesProjectCell.h
//  Recity
//
//  Created by Vitaliy Zhukov on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCProject, RCAddress;

@interface RCDINearbyTypesProjectCell : UITableViewCell

- (void)updateWithProject:(RCProject *)project andAddress:(RCAddress *)address;

@end
