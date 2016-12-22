//
//  RCFilterManager.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterManager.h"
#import "RCFilterTableModel.h"

#import "RCProject.h"
#import "RCMapController.h"

@interface FilterConfig : NSObject

@property (nonatomic) BOOL filteringEnabled;

@property (strong, nonatomic) NSArray <NSString *> *statuses;
@property (strong, nonatomic) NSArray <NSString *> *propertyTypes;
@property (nonatomic) BOOL showRehabs;

@property (nonatomic) CGFloat completionYearStart;
@property (nonatomic) CGFloat completionYearEnd;
@property (nonatomic) BOOL includeTBD;

@property (nonatomic) CGFloat landSizeMin;
@property (nonatomic) CGFloat landSizeMax;

@property (nonatomic) CGFloat buildingSizeMin;
@property (nonatomic) CGFloat buildingSizeMax;

@property (nonatomic) CGFloat floorsMin;
@property (nonatomic) CGFloat floorsMax;

- (NSDictionary *)configuration;

@end

@implementation FilterConfig

- (NSDictionary *)configuration
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:self.propertyTypes
               forKey:@"Property Type"];
    [result setObject:self.statuses
               forKey:@"Status"];
    [result setObject:@(self.completionYearStart)
               forKey:@"Completion year - bottom"];
    [result setObject:@(self.completionYearEnd)
               forKey:@"Completion year - top"];
    NSString *include = self.includeTBD ? @"Yes" : @"No";
    [result setObject:include
               forKey:@"Include TBD"];
    [result setObject:@(self.landSizeMin)
               forKey:@"Min land square footage"];
    [result setObject:@(self.landSizeMax)
               forKey:@"Max land square footage"];
    [result setObject:@(self.buildingSizeMin)
               forKey:@"Min building square footage"];
    [result setObject:@(self.buildingSizeMax)
               forKey:@"Max building square footage"];
    [result setObject:@(self.floorsMin)
               forKey:@"Min number of floors"];
    [result setObject:@(self.floorsMax)
               forKey:@"Max number of floors"];
    return result;
}

@end

@interface RCFilterManager() <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) FilterConfig *currentConfig;
@property (strong, nonatomic) FilterConfig *defaultConfig;

@property (strong, nonatomic) NSArray <RCProject *> *projects;
@property (strong, nonatomic) NSArray <RCFilterTableModel *> *tmpDataModel;

@end

@implementation RCFilterManager

SINGLETON_OBJECT

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
        [self registerNotification:YES];
        [self tableDataModel];
    }
    return self;
}

- (void)dealloc
{
    [self registerNotification:NO];
}

- (void)registerNotification:(BOOL)enabled
{
    if (enabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFilteredProjects) name:kNotificationProjectsLoaded object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setFilteringEnabled:(BOOL)filteringEnabled
{
    self.currentConfig.filteringEnabled = filteringEnabled;
    [self updateModel];
}

- (BOOL)isFilteringEnabled
{
    return self.currentConfig.filteringEnabled;
}

- (void)setupDefaults
{
    [self applyConfig:self.defaultConfig];
}

- (void)applyConfig:(FilterConfig *)config
{
    self.currentConfig = config;
    [self updateModel];
}

- (void)updateModel
{
    [self updateFilteredProjects];
    [self updateDataModel:self.currentConfig];
}

- (void)resetFilters
{
    FilterConfig *defConf = self.defaultConfig;
    defConf.filteringEnabled = YES;
    [self updateDataModel:defConf];
}

- (BOOL)isFilteredProjectsContainsProject:(RCProject *)project
{
    return [[_projects valueForKeyPath:@"uid"] containsObject:project.uid];
}

- (void)updateFilteredProjects
{
    NSArray *projects = nil;
    
    if (self.currentConfig.filteringEnabled) {
        FilterConfig *config = self.currentConfig;
        
        if (!config.statuses.isFull || !config.propertyTypes.isFull) {
            RCProject *selected = [self selectedProject];
            if (selected) {
                projects = @[selected];
            }
            self.projects = projects;
            return;
        }
        
        NSPredicate *landSize = [NSPredicate predicateWithFormat:@"landSize > %f and landSize < %f", config.landSizeMin, config.landSizeMax];
        NSPredicate *buildingSize = [NSPredicate predicateWithFormat:@"(buildingSize > %f and buildingSize < %f) or (estimatedBuildingSize > %f and estimatedBuildingSize < %f)", config.buildingSizeMin, config.buildingSizeMax, config.buildingSizeMin, config.buildingSizeMax];
        NSPredicate *floors = [NSPredicate predicateWithFormat:@"(floorCount > %f and floorCount < %f) or (estimatedFloorCount > %f and estimatedFloorCount < %f)", config.floorsMin, config.floorsMax, config.floorsMin, config.floorsMax];
        NSPredicate *status = [NSPredicate predicateWithFormat:@"status IN %@", config.statuses];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *propTypeString in config.propertyTypes) {
            [arr addObject:[NSPredicate predicateWithFormat:@"typeDetails.%@ == %@", propTypeString, @(YES)]];
        }
        NSCompoundPredicate *propertyType = [NSCompoundPredicate orPredicateWithSubpredicates:arr];
        
        arr = [NSMutableArray array];
        for (NSInteger i = 2010; i < 2031; i++) {
            if (i >= config.completionYearStart && i <= config.completionYearEnd) {
                [arr addObject:[NSPredicate predicateWithFormat:@"completionDate contains %@", [NSString stringWithFormat:@"%ld", (long)i]]];
            }
        }
        if (config.includeTBD) {
            [arr addObject:[NSPredicate predicateWithFormat:@"completionDate == %@", [NSNull null]]];
        }
        NSCompoundPredicate *year = [NSCompoundPredicate orPredicateWithSubpredicates:arr];
        
        arr = [@[propertyType, status, year, landSize, buildingSize, floors] mutableCopy];
        
        if (!config.showRehabs) {
            [arr addObject:[NSPredicate predicateWithFormat:@"constructionType == %@", @"NewConstruction"]];
        }
        
        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:arr];
        
        projects = [RCProject MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    } else {
        projects = [RCProject MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    
    self.projects = projects;
}

- (RCProject *)selectedProject
{
    return [RCMapController selectedProject];
}

- (NSArray<RCProject *> *)projects
{
    if (!_projects) {
        [self updateFilteredProjects];
    }
    RCProject *selectedProject = [self selectedProject];
    if (selectedProject) {
        if (![self isFilteredProjectsContainsProject:selectedProject]) {
            return [_projects arrayByAddingObject:selectedProject];
        }
    }
    return _projects;
}

- (NSArray <RCFilterTableModel *> *)tableDataModel
{
    if (self.tmpDataModel) {
        return self.tmpDataModel;
    }
    
    RCFilterTableModel *enabler = [RCFilterTableModel modelWithTitle:nil cellType:RCFilterCellTypeFiltersEnabled];
    
    RCFilterTableModel *propType = [RCFilterTableModel modelWithTitle:@"Property Type" cellType:RCFilterCellTypeGroupSelector];
    propType.values = [self propertyValues];
    
    RCFilterTableModel *status = [RCFilterTableModel modelWithTitle:@"Status" cellType:RCFilterCellTypeGroupSelector];
    status.values = [self statusValues];
    
    RCFilterTableModel *year = [RCFilterTableModel modelWithTitle:@"Completion Year" cellType:RCFilterCellTypeDateSelector];
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 2010; i < 2031; i++) {
        [values addObject:@(i)];
    }
    year.values = values;
    
    RCFilterTableModel *landSize = [RCFilterTableModel modelWithTitle:@"Land Square Footage" cellType:RCFilterCellTypeSlider];
    landSize.values = @[@(0), @(5000), @(10000), @(25000), @(50000), @(100000), @(250000), @(10000000)];
    
    RCFilterTableModel *buildSize = [RCFilterTableModel modelWithTitle:@"Building Square Footage" cellType:RCFilterCellTypeSlider];
    buildSize.values = @[@(0), @(10000), @(25000), @(50000), @(100000), @(250000), @(500000), @(10000000)];
    
    RCFilterTableModel *floors = [RCFilterTableModel modelWithTitle:@"Number of Floors" cellType:RCFilterCellTypeSlider];
    floors.values = @[@(0), @(3), @(5), @(10), @(20), @(10000000)];
    
    self.tmpDataModel = @[enabler, propType, status, year, landSize, buildSize, floors];
    
    [self updateDataModel:self.defaultConfig];
    
    return self.tmpDataModel;
}

- (NSArray <RCFilterSelectorModel *> *)statusValues
{
    RCFilterSelectorModel *recently = [RCFilterSelectorModel new];
    recently.title = @"Recently Completed";
    recently.filterKey = @"Completed";
    RCFilterSelectorModel *construction = [RCFilterSelectorModel new];
    construction.title = @"Under Construction";
    construction.filterKey = @"UnderConstruction";
    RCFilterSelectorModel *planned = [RCFilterSelectorModel new];
    planned.title = @"Planned";
    planned.filterKey = @"Planned";
    RCFilterSelectorModel *unannonced = [RCFilterSelectorModel new];
    unannonced.title = kUnannounced;
    unannonced.filterKey =  kUnannounced;
    return @[recently, construction, planned, unannonced];
}

- (NSArray *)propertyValues
{
    RCFilterTableModel *rehabs = [RCFilterTableModel modelWithTitle:nil cellType:RCFilterCellTypeFiltersEnabled];
    rehabs.switchEnabled = YES;
    
    RCFilterSelectorModel *residential = [RCFilterSelectorModel new];
    residential.title = @"Residential";
    RCFilterSelectorModel *apartments = [RCFilterSelectorModel new];
    apartments.title = @"Apartments";
    apartments.filterKey = @"apartments";
    RCFilterSelectorModel *condos = [RCFilterSelectorModel new];
    condos.title = @"Condos";
    condos.filterKey = @"condominiums";
    RCFilterSelectorModel *tbd = [RCFilterSelectorModel new];
    tbd.title = kTBD;
    tbd.filterKey = @"residentialTbd";

    [residential addChild:apartments];
    [residential addChild:condos];
    [residential addChild:tbd];
    
    RCFilterSelectorModel *office = [RCFilterSelectorModel new];
    office.title = @"Office";
    office.filterKey = @"office";
    RCFilterSelectorModel *retail = [RCFilterSelectorModel new];
    retail.title = @"Retail";
    retail.filterKey = @"retail";
    RCFilterSelectorModel *hotel = [RCFilterSelectorModel new];
    hotel.title = @"Hotel";
    hotel.filterKey = @"hotel";
    RCFilterSelectorModel *theatre = [RCFilterSelectorModel new];
    theatre.title = @"Theatre/Entertainment";
    theatre.filterKey = @"entertainment";
    RCFilterSelectorModel *other = [RCFilterSelectorModel new];
    other.title = @"Other";
    other.filterKey = @"otherType";
    
    return @[rehabs, residential, apartments, condos, tbd, office, retail, hotel, theatre, other];
}

- (void)updateDataModel:(FilterConfig *)config
{
    NSArray <RCFilterTableModel *> *data = self.tmpDataModel;

    data[0].switchEnabled = config.filteringEnabled;
    
    data[1].selectedValues = config.propertyTypes;
    RCFilterTableModel *rehubEnabled = data[1].values[0];
    rehubEnabled.switchEnabled = config.showRehabs;
    
    data[2].selectedValues = config.statuses;
    data[3].currentMin = @(config.completionYearStart);
    data[3].currentMax = @(config.completionYearEnd);
    data[3].switchEnabled = config.includeTBD;
    data[4].currentMin = @(config.landSizeMin);
    data[4].currentMax = @(config.landSizeMax);
    data[5].currentMin = @(config.buildingSizeMin);
    data[5].currentMax = @(config.buildingSizeMax);
    data[6].currentMin = @(config.floorsMin);
    data[6].currentMax = @(config.floorsMax);
}

- (void)saveChanges
{
    [self applyConfig:self.configForCurrentDataState];
}

- (void)discardChanges
{
    [self updateDataModel:self.currentConfig];
}

- (BOOL)isFiltersSwitcherOn
{
    return self.configForCurrentDataState.filteringEnabled;
}

- (BOOL)isCurrentConfigDefault
{
    BOOL result = YES;
    
    FilterConfig *current = self.configForCurrentDataState;
    FilterConfig *defConfig = self.defaultConfig;
    
    for (NSString *string in defConfig.propertyTypes) {
        result = result && [current.propertyTypes containsObject:string];
    }
    for (NSString *string in defConfig.statuses) {
        result = result && [current.statuses containsObject:string];
    }
    
    result = result && current.showRehabs == defConfig.showRehabs;
    result = result && current.completionYearStart == defConfig.completionYearStart;
    result = result && current.completionYearEnd == defConfig.completionYearEnd;
    result = result && current.includeTBD == defConfig.includeTBD;
    result = result && current.landSizeMin == defConfig.landSizeMin;
    result = result && current.landSizeMax == defConfig.landSizeMax;
    result = result && current.buildingSizeMin == defConfig.buildingSizeMin;
    result = result && current.buildingSizeMax == defConfig.buildingSizeMax;
    result = result && current.floorsMin == defConfig.floorsMin;
    result = result && current.floorsMax == defConfig.floorsMax;
    
    return result;
}

- (FilterConfig *)defaultConfig
{
    FilterConfig *defaultConfig = [FilterConfig new];
    defaultConfig.propertyTypes = @[@"apartments", @"condominiums", @"residentialTbd", @"retail",
                                     @"office", @"hotel", @"entertainment", @"otherType"];
    defaultConfig.showRehabs = YES;
    defaultConfig.statuses = @[@"Completed", @"Planned", @"UnderConstruction"];
    
    if ([AppState advancedVersion]) {
        defaultConfig.statuses = [defaultConfig.statuses arrayByAddingObject:kUnannounced];
    }
    
    defaultConfig.filteringEnabled = YES;
    defaultConfig.completionYearStart = 2010;
    defaultConfig.completionYearEnd = 2030;
    defaultConfig.includeTBD = YES;
    defaultConfig.landSizeMin = 0;
    defaultConfig.landSizeMax = 10000000;
    defaultConfig.buildingSizeMin = 0;
    defaultConfig.buildingSizeMax = 10000000;
    defaultConfig.floorsMin = 0;
    defaultConfig.floorsMax = 10000000;
    
    return defaultConfig;
}

- (FilterConfig *)configForCurrentDataState
{
    NSArray <RCFilterTableModel *> *data = self.tmpDataModel;
    
    FilterConfig *config = [FilterConfig new];
    
    config.filteringEnabled = data[0].switchEnabled;
    config.propertyTypes = data[1].selectedValues;
    config.showRehabs = [(RCFilterTableModel *)data[1].values[0] switchEnabled];
    config.statuses = data[2].selectedValues;
    config.completionYearStart = data[3].currentMin.floatValue;
    config.completionYearEnd = data[3].currentMax.floatValue;
    config.includeTBD = data[3].switchEnabled;
    config.landSizeMin = data[4].currentMin.floatValue;
    config.landSizeMax = data[4].currentMax.floatValue;
    config.buildingSizeMin = data[5].currentMin.floatValue;
    config.buildingSizeMax = data[5].currentMax.floatValue;
    config.floorsMin = data[6].currentMin.floatValue;
    config.floorsMax = data[6].currentMax.floatValue;
    
    return config;
}

- (NSDictionary *)currentConfiguration
{
    return [self.currentConfig configuration];
}

@end

