//
//  RCSearchCell+Recent.h
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchCell.h"

@interface RCSearchCell()

@property (weak, nonatomic) IBOutlet UILabel *titleRecent;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectSubLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

- (void)prepareAllHide;
- (void)prepareImage:(NSString *)imageName;
- (void)prepareCenterLabelText:(NSString *)text;

@end
