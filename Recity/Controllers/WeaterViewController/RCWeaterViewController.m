//
//  RCWeaterViewController.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeaterViewController.h"

#import "RCWeaterViewController_Private.h"
#import "RCGetWeater.h"


@import CoreLocation;

@interface RCWeaterViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation RCWeaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTap];
    [self prepareMyLocation];
    [self sendToServer];
}

- (void)sendToServer{
    __weak __typeof__(self) weakSelf = self;
    [RCGetWeater withObject:self.parameters completion:^(id reply, NSError *error, BOOL *handleError) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (reply != NULL) {
            [strongSelf prepareMap:reply];
        }
    }];
}

- (NSDictionary *)parameters{
    NSString *text = self.text;
    return text.isFull ? @{@"q":text} :self.coordinateParameters;
}
/**
 *  Parameters location
 */
- (NSDictionary *)coordinateParameters{
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    return @{@"lat":@(coordinate.latitude),@"lon":@(coordinate.longitude)};
}

- (void)prepareMyLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    self.locationManager = locationManager;
}

+ (NSString *)storyboardName {
    return @"RCWeaterViewController";
}

@end
