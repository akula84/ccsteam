//
//  RCCondosApartmentsMetric.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCCondosApartmentsMetric.h"

#import "RCPredicateFactory.h"
#import "RCAddress.h"
#import "RCIndexUtils.h"
#import "RCProject.h"
#import "RCCondosApartmentsView.h"

@implementation RCCondosApartmentsMetric

- (void)loadItem
{
    NSArray *allProject = [self.address nearbyProjectNotUnannounce];
    
    NSArray *condominiums = [allProject filteredArrayUsingPredicate:[RCPredicateFactory predCondominiums]];
    self.condosTotal = [self valueResidentialUnits:condominiums];
    NSArray *apartments = [allProject filteredArrayUsingPredicate:[RCPredicateFactory predApartments]];
    self.aptsTotal = [self valueResidentialUnits:apartments];
    NSArray *residentialTbd = [allProject filteredArrayUsingPredicate:[RCPredicateFactory predResidentialTbd]];
    self.projectTbd = @(residentialTbd.count);
    
    NSUInteger checkCount = condominiums.count + apartments.count + residentialTbd.count;
    if (checkCount < 2) {
        self.descriptionTitle = kNotEnough;
        self.enabled = NO;
        return;
    }
    self.enabled = YES;
    
    NSPredicate *predCompleted = [RCPredicateFactory predCompleted];
    NSArray *condominiumsComplete = [condominiums filteredArrayUsingPredicate:predCompleted];
    self.condosComplete = [self valueResidentialUnits:condominiumsComplete];
    NSArray *apartmentsComplete = [apartments filteredArrayUsingPredicate:predCompleted];
    self.aptsComplete = [self valueResidentialUnits:apartmentsComplete];
    
    NSPredicate *predUpcoming = [RCPredicateFactory predUpcoming];
    NSArray *condominiumsUpcoming = [condominiums filteredArrayUsingPredicate:predUpcoming];
    self.condosUpcoming = [self valueResidentialUnits:condominiumsUpcoming];
    NSArray *apartmentsUpcoming = [apartments filteredArrayUsingPredicate:predUpcoming];
    self.aptsUpcoming = [self valueResidentialUnits:apartmentsUpcoming];
    
    [self prepareDescription];
}

- (void)prepareDescription
{
    NSString *key;
    NSComparisonResult compare = [self.aptsTotal compare:self.condosTotal];
    switch (compare) {
       case NSOrderedAscending:
            key = @"More Condos Planned";
            break;
       case NSOrderedSame:
            key = @"Similar Outlook";
            break;
       case NSOrderedDescending:
            key = @"More Apartments Planned";
            break;
        default:
            break;
    }
    self.descriptionTitle = key;
}

- (NSNumber *)valueResidentialUnits:(NSArray *)array
{
    return [RCIndexUtils valueResidentialUnits:array];
}

- (UIView *)viewForMetric
{
    RCCondosApartmentsView *metricView = [[RCCondosApartmentsView alloc] initForAutoLayout];
    [metricView setModel:self];
    return metricView;
}

- (CGFloat)heightForView
{
    CGFloat size = 257.f;
    if (self.projectTbd.isFull){
        size = size + 55.f;
    }
    return size;
}

@end
