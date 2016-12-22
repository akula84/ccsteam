//
//  RCFilterTableModel.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterTableModel.h"

@implementation RCFilterTableModel

+ (instancetype)modelWithTitle:(NSString *)title cellType:(RCFilterCellType)cellType
{
    RCFilterTableModel *model = [RCFilterTableModel new];
    model.title = title;
    model.cellType = cellType;
    
    return model;
}

- (NSString *)selectionDescription
{
    NSString *description = @"None";
    
    if (self.selectedValues.count == [self selectedAllCount]) {
        description = @"All";
    } else {
        if (self.selectedValues.isFull) {
            
            NSMutableArray *strings = [NSMutableArray array];
            
            for (id item in self.values) {
                if ([item isKindOfClass:[RCFilterSelectorModel class]]) {
                    RCFilterSelectorModel *model = item;
                    if ([self.selectedValues containsObject:model.filterKey]) {
                        [strings addObject:model.title];
                    }
                }
            }
            
            description = [strings componentsJoinedByString:@", "];
        }
    }
    
    return description;
}

- (void)setSelectedValues:(NSArray *)selectedValues
{
    for (id value in self.values) {
        if ([value isKindOfClass:[RCFilterSelectorModel class]]) {
            RCFilterSelectorModel *model = value;
            
            BOOL isSelected = [selectedValues containsObject:model.filterKey];
            
            if (!model.children.isFull) {
                if (model.checkboxState == RCFilterCheckboxStateUnchecked && isSelected) {
                    [model switchState];
                }
                if (model.checkboxState == RCFilterCheckboxStateChecked && !isSelected) {
                    [model switchState];
                }
            }
        }
    }
}

- (NSArray *)selectedValues
{
    NSMutableArray *selected = [NSMutableArray array];
    for (id value in self.values) {
        if ([value isKindOfClass:[RCFilterSelectorModel class]]) {
            RCFilterSelectorModel *model = value;
            if (!model.children.isFull && model.checkboxState == RCFilterCheckboxStateChecked) {
                [selected addObject:model.filterKey];
            }
        }
    }
    
    return selected;
}

- (NSUInteger)selectedAllCount
{
    NSUInteger count = 0;
    for (id value in self.values) {
        if ([value isKindOfClass:[RCFilterSelectorModel class]]) {
            RCFilterSelectorModel *model = value;
            if (!model.children.isFull) {
                count++;
            }
        }
    }
    return count;
}

@end

@interface RCFilterSelectorModel()

@property (nonatomic) RCFilterCheckboxState checkboxState;
@property (weak, nonatomic) RCFilterSelectorModel *parent;
@property (strong, nonatomic) NSArray <RCFilterSelectorModel *> *children;

@end

@implementation RCFilterSelectorModel

- (void)addChild:(RCFilterSelectorModel *)child
{
    child.parent = self;
    self.children = [self.children arrayByAddingObject:child];
}

- (void)switchState
{
    switch (self.checkboxState) {
        case RCFilterCheckboxPartial:
        case RCFilterCheckboxStateChecked: {
            self.checkboxState = RCFilterCheckboxStateUnchecked;
            [self setChildrenState:NO];
            break;
        }
        case RCFilterCheckboxStateUnchecked: {
            self.checkboxState = RCFilterCheckboxStateChecked;
            [self setChildrenState:YES];
            break;
        }
    }
    [self updateParentCheckboxState];
}

- (void)updateParentCheckboxState
{
    NSUInteger checkedChildrenCount = 0;
    
    RCFilterSelectorModel *parent = self.parent;
    
    for (RCFilterSelectorModel *child in parent.children) {
        if (child.checkboxState == RCFilterCheckboxStateChecked) {
            checkedChildrenCount++;
        }
    }
    
    RCFilterCheckboxState state;
    if (checkedChildrenCount == 0) {
        state = RCFilterCheckboxStateUnchecked;
    } else if (checkedChildrenCount == parent.children.count) {
        state = RCFilterCheckboxStateChecked;
    } else {
        state = RCFilterCheckboxPartial;
    }
    parent.checkboxState = state;
}

- (void)setChildrenState:(BOOL)checked
{
    for (RCFilterSelectorModel *child in self.children) {
        child.checkboxState = checked ? RCFilterCheckboxStateChecked : RCFilterCheckboxStateUnchecked;
    }
}

- (NSArray <RCFilterSelectorModel *> *)children
{
    if (!_children) {
        _children = [NSArray array];
    }
    return _children;
}

- (NSString *)description
{
    return self.title;
}

@end
