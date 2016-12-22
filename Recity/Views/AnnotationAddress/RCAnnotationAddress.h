//
//  AnnotationAddress.h
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotationProtocol.h"

@class RCAddress;

@interface RCAnnotationAddress : NSObject <RCAnnotationProtocol>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) CLLocationCoordinate2D tempoCoordinate;
@property (strong, nonatomic) RCAddress *address;

+ (instancetype)itemWithAddress:(RCAddress *)address;

@end
