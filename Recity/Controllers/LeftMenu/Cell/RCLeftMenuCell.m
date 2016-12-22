//
//  RCLeftMenuCell.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCLeftMenuCell.h"

#import "RCVKSideMenuItem.h"

@interface RCLeftMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLineUp;

@end

@implementation RCLeftMenuCell

- (void)setItem:(RCVKSideMenuItem *)item
{
    self.myImageView.image = [UIImage imageNamed:item.imageName];
    self.title.text = item.title;
}

@end
