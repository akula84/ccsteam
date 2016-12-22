//
//  RCAnnotation.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 27.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotationProtocol.h"

@class RCProject;

@interface RCAnnotationProject : NSObject <RCAnnotationProtocol>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) CLLocationCoordinate2D tempoCoordinate;
@property (strong, nonatomic) RCProject *project;

+ (instancetype)itemWithProject:(RCProject *)project;

@end
