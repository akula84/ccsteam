//
//  RCDINearbyTypesViewController.h
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCProject, RCAddress, RCSegmentedProcentageSelector;

@interface RCDINearbyTypesViewController : UIViewController

@property (strong, nonatomic) RCAddress *address;
@property (strong, nonatomic) NSString *groupTitle;
@property (strong, nonatomic) NSArray <RCProject *> *projects;
@property (weak, nonatomic) IBOutlet RCSegmentedProcentageSelector *segmentedSelector;

- (CGFloat)viewHeight;

@end
