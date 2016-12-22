//
//  RCProjectDetail.h
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCAddress;

@interface RCProjectDetail : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *describing;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *imageURLstring;
@property (assign, nonatomic) NSInteger row;

@property (strong, nonatomic) RCAddress *address;

- (instancetype)initWithTitle:(NSString *)title;

@end
