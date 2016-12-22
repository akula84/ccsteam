//
//  RCAnnotation.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 27.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotationProject.h"

#import "RCProject.h"
#import "RCPoint.h"

@interface RCAnnotationProject()

@property (assign, nonatomic) CLLocationCoordinate2D searchCoordinate;

@end

@implementation RCAnnotationProject

+ (instancetype)itemWithProject:(RCProject *)project
{
    RCAnnotationProject *result = [RCAnnotationProject new];
    RCPoint *pt = project.centerPoint;
    CGFloat latitude = [pt.latitude floatValue];
    CGFloat longitude = [pt.longitude floatValue];
    result.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    result.project = project;
    
    result.searchCoordinate = result.coordinate;
    return result;
}

- (UIImage *)image
{
    NSString *imageName = ({
        NSString *markerImageName;
        RCProject *project = self.project;
        if ([project isSelected]) {
            markerImageName = @"projectSelected";
        }else{
            markerImageName = [project mapPinImageNameForUser:[AppState sharedInstance].user];
        }
        markerImageName;
    });
    UIImage *image;
    if (imageName) {
        image = [UIImage imageNamed:imageName];
    } else {
        image = [UIImage new];
    }
    return image;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"lat:%f, lon:%f, TEMPO: lat: %f, long: %f", self.coordinate.latitude, self.coordinate.longitude, self.tempoCoordinate.latitude, self.tempoCoordinate.longitude];
}

@end
