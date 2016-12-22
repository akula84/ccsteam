//
//  RCDevelopmentIndexTableViewCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexTableViewCell.h"

#import "RCAreaPermitMetric.h"

@interface RCDevelopmentIndexTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *metricContentView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *statusSignImageView;

@property (strong, nonatomic) RCDevelopmentIndexMetricModel *model;

@end

@implementation RCDevelopmentIndexTableViewCell

- (void)updateWithModel:(RCDevelopmentIndexMetricModel *)model
{
    self.model = model;
    
    [self updateHeader];
    
    [self updateForState:model.opened];
    [self updateData];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    for (UIView *view in self.contentView.subviews) {
        view.alpha = userInteractionEnabled ? 1.0f : 0.3f;
    }
}

- (void)updateData
{
    RCDevelopmentIndexMetricModel *model = self.model;
    if ([model isKindOfClass:[RCAreaPermitMetric class]]) {
        ((RCAreaPermitMetric *)model).update = ^(){
            [self updateHeader];
        };
    }
}

- (void)updateHeader
{
    RCDevelopmentIndexMetricModel *model = self.model;
    self.titleLabel.text = [model.title uppercaseString];
    self.descriptionLabel.text = model.description;
    self.userInteractionEnabled = model.enabled;
}

- (void)updateForState:(BOOL)opened
{
    if (opened) {
        UIView *metricView = [self metricView];
        self.statusSignImageView.image = IMG(@"minus_button");
        
        [self.metricContentView addSubview:metricView];
        [metricView autoPinEdgesToSuperviewEdges];
    } else {
        self.statusSignImageView.image = IMG(@"plus_button");
        [self cleanContentView];
    }
}

- (IBAction)stateChangeButtonAction:(id)sender
{
    [self.delegate stateChangeNeededForCell:self];
}

- (void)prepareForReuse
{
    self.model = nil;
    [self cleanContentView];
}

- (void)cleanContentView
{
    for (UIView *view in self.metricContentView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}

- (UIView *)metricView
{
   return [self.model viewForMetric];
}

@end
