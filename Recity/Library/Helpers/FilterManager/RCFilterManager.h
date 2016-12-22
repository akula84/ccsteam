//
//  RCFilterManager.h
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@class RCProject, RCFilterTableModel;

@interface RCFilterManager : NSObject

@property (nonatomic, strong, readonly) NSArray <RCFilterTableModel *> *tableDataModel;

@property (strong, nonatomic, readonly) NSArray <RCProject *> *projects;

@property (nonatomic, getter=isFilteringEnabled) BOOL filteringEnabled;

- (BOOL)isFiltersSwitcherOn;
- (BOOL)isCurrentConfigDefault;

- (void)saveChanges;
- (void)discardChanges;
- (void)resetFilters;
- (void)setupDefaults;

- (BOOL)isFilteredProjectsContainsProject:(RCProject *)project;

- (NSDictionary *)currentConfiguration;

@end
