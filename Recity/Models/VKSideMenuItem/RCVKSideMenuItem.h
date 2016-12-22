//
//  RCVKSideMenuItem.h
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//


@interface RCVKSideMenuItem : NSObject

+ (instancetype)itemImageName:(NSString *)imageName title:(NSString *)title;

@property (strong ,nonatomic) NSString *imageName;
@property (strong ,nonatomic) NSString *title;

@end
