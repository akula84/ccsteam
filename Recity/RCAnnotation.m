//
//  RCAnnotation.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 27.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotation.h"

@implementation RCAnnotation

- (NSString *)description {
    return [NSString stringWithFormat:@"lat:%f, lon:%f, TEMPO: lat: %f, long: %f", self.coordinate.latitude, self.coordinate.longitude, self.tempoCoordinate.latitude, self.tempoCoordinate.longitude];
}

@end
