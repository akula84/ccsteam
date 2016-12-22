//
//  FBAnnotationCluster.m
//  AnnotationClustering
//
//  Created by Filip Bec on 06/01/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FBAnnotationCluster.h"

@implementation FBAnnotationCluster

- (NSString *)description {
    return [NSString stringWithFormat:@"count: %lu, lat:%f, lon:%f, TEMPO: lat: %f, long: %f", (unsigned long)self.annotations.count, self.coordinate.latitude, self.coordinate.longitude, self.tempoCoordinate.latitude, self.tempoCoordinate.longitude];
}

- (BOOL)isEqual:(FBAnnotationCluster *)object {
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[FBAnnotationCluster class]]) {
        return NO;
    }
    BOOL sameAnnotationsCount = self.annotations.count == object.annotations.count;
    BOOL result = sameAnnotationsCount &&
        self.coordinate.latitude == object.coordinate.latitude &&
        self.coordinate.longitude == object.coordinate.longitude;
    
    return result;
}

- (NSUInteger)hash {
    NSUInteger hash = [@(self.annotations.count)hash];
    hash += [[NSValue valueWithMKCoordinate:self.coordinate] hash];
    
    return hash;
}

@end
