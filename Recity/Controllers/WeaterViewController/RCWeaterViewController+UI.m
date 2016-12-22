//
//  RCWeaterViewController+UI.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeaterViewController_Private.h"

#import "RCMap+CoreDataClass.h"
#import "RCMain+CoreDataClass.h"
#import "RCWeather+CoreDataClass.h"
#import "UIImageView+AFNetworking.h"

@implementation RCWeaterViewController (UI)

- (void)hideKeyBoard{
    [self.textField resignFirstResponder];
}

- (IBAction)locationAction:(id)sender {
    [self hideKeyBoard];
    self.textField.text = @"";
    [self textFieldChanged:self.textField];
}

- (void)prepareMap:(id)object{
    RCMap *map = object;
    self.nameTitle.text = map.name;
    
    CGFloat temp = map.main.temp.floatValue - 273;
    self.tempLabel.text = [NSString stringWithFormat:@"%.2fC",temp];
    
    RCWeather *weater = [map.weather allObjects].firstObject;
    self.mainLabel.text = weater.main;
    
    NSString *urlString = [kAPIBaseURL stringByAppendingFormat:@"%@%@.png",kImage,weater.icon];
    [self.iconImage setImageWithURL:[NSURL URLWithString:urlString]];
}

@end
