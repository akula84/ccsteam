//
//  RCClusterAnnotation.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 28.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCClusterAnnotationView.h"
#import "RCClusterView.h"

@interface RCClusterAnnotationView ()

@property (weak, nonatomic) RCClusterView *clusterView;

@end

@implementation RCClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        RCClusterView *clusterView = [RCClusterView new];
        self.clusterView = clusterView;
        self.frame = clusterView.bounds;
        [self addSubview:clusterView];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setCount:0];
}

- (void)setCount:(NSUInteger)count {
    [self.clusterView setCount:count];
}

@end
