//
//  RCFilterTableModel.h
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

typedef NS_ENUM(NSInteger, RCFilterCellType) {
    RCFilterCellTypeFiltersEnabled,
    RCFilterCellTypeGroupSelector,
    RCFilterCellTypeDateSelector,
    RCFilterCellTypeSlider
};

typedef NS_ENUM(NSInteger, RCFilterCheckboxState) {
    RCFilterCheckboxStateUnchecked,
    RCFilterCheckboxStateChecked,
    RCFilterCheckboxPartial,
};

@interface RCFilterTableModel : NSObject

+ (instancetype)modelWithTitle:(NSString *)title cellType:(RCFilterCellType)cellType;

@property (nonatomic) RCFilterCellType cellType;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *values;
@property (nonatomic, strong) NSArray  *selectedValues;
@property (nonatomic, strong) NSNumber *currentMin;
@property (nonatomic, strong) NSNumber *currentMax;
@property (nonatomic) BOOL switchEnabled;

@property (nonatomic, strong) NSString *selectionDescription;

@end

@protocol RCFilterTableCell <NSObject>

- (void)updateWithModel:(RCFilterTableModel *)model;

@end

@interface RCFilterSelectorModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *filterKey;
@property (nonatomic, readonly) RCFilterCheckboxState checkboxState;

@property (weak, nonatomic, readonly) RCFilterSelectorModel *parent;
@property (strong, nonatomic, readonly) NSArray <RCFilterSelectorModel *> *children;

- (void)addChild:(RCFilterSelectorModel *)child;
- (void)switchState;

@end
