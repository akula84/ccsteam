//
//  TCDTableManager.m
//  PseudoSafari
//
//  Created by Dmitriy Doroschuk on 15.03.16.
//  Copyright © 2016 TCD. All rights reserved.
//

#import "RCTableManager.h"

@implementation RCTableManager

#pragma mark - LifeStyle

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Configure

- (void)setItems:(NSArray *)items {
    if (items) {
        RCTableSection *section = [RCTableSection new];
        section.items = items;
        _sections = @[section];
    } 
    [self reloadData];
}

- (NSArray *)items {
    NSArray *result;
    if (self.sections.count) {
        RCTableSection *section = self.sections[0];
        result = section.items;
    }
    return result;
}

- (void)setSections:(NSArray *)sections {
    _sections = [sections copy];
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView {
    UITableView *oldTable = _tableView;
    oldTable.dataSource = nil;
    oldTable.delegate = nil;
    
    _tableView = tableView;
    
    tableView.delaysContentTouches = NO;
    
    NSArray *cellNibNames = [self cellNibNames];
    for (NSString *nibName in cellNibNames) {
        UINib *cellNib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [tableView registerNib:cellNib forCellReuseIdentifier:nibName];
    }
    
    tableView.dataSource = self;
    tableView.delegate = self;
}

//      this and next method for dispaying of default table separators with UIEdgeInsetsZero
- (void)setUseSeparatorsZeroInset:(BOOL)useSeparatorsZeroInset {
    _useSeparatorsZeroInset = useSeparatorsZeroInset;
    if (_useSeparatorsZeroInset) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self numberOfRowsInSection:(NSUInteger)section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat result = 0.00001f;
    RCTableSection *tableSection;
    if (section < (NSInteger)self.sections.count) {
        tableSection = self.sections[(NSUInteger)section];
        if(tableSection.isShowHeader)
            result = [self heightForHeaderViewOfSection:tableSection];
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *result = 0;
    RCTableSection *tableSection;
    if (section < (NSInteger)self.sections.count) {
        tableSection = self.sections[(NSUInteger)section];
        NSString *headerIdentifier = [self headerIdentifierForSection:tableSection];
        if (tableSection.isShowHeader && headerIdentifier) {
            result = [UIView loadFromNib:headerIdentifier];
            [self configureHeaderView:result forSection:tableSection];
        }
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *result = 0;
    RCTableSection *tableSection;
    if (section < (NSInteger)self.sections.count) {
        tableSection = self.sections[(NSUInteger)section];
        NSString *footerIdentifier = [self footerIdentifierForSection:tableSection];
        if (footerIdentifier) {
            result = [UIView loadFromNib:footerIdentifier];
            [self configureFooterView:result forSection:tableSection];
        }
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat result = 0;
    RCTableSection *tableSection;
    if (section < (NSInteger)self.sections.count) {
        tableSection = self.sections[(NSUInteger)section];
        result = [self heightForFooterViewOfSection:tableSection];
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [self cellIdentifierForItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
    UITableViewCell *cell = nil;
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    @catch (NSException *exception) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"some not real cell id"];
    }    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = [self shouldHighlightAndSelectCellAtIndexPath:indexPath];
    return result;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForItem:[self itemByIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RUN_BLOCK(self.didSelectedCellWithItemBlock, [self itemByIndexPath:indexPath]);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_useSeparatorsZeroInset) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {//     http://stackoverflow.com/a/25764606/3627460
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    [self configureCell:cell withItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
}

#pragma mark - From Childs

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    ///enough for current feature
    NSUInteger result = 0;
    if (section < self.sections.count) {
        RCTableSection *tableSection = self.sections[section];
        result = [tableSection.items count];
    }
    return result;
}

- (id)itemByIndexPath:(NSIndexPath *)indexPath {
    id item = nil;

    RCTableSection *section = self.sections[(NSUInteger)indexPath.section];
    NSArray *sectionItems = section.items;
    item = sectionItems[(NSUInteger)indexPath.row];

    return item;
}

- (id)itemByCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath == nil) {
        NSParameterAssert(indexPath);
        
        return nil;
    }
    return [self itemByIndexPath:indexPath];
}

- (NSArray *)indexPathsOfItem:(id)item inSections:(NSArray <RCTableSection *> *)sections {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSUInteger i = 0; i < self.sections.count; ++i) {
        RCTableSection *currentSection = self.sections[i];
        if ([sections containsObject:currentSection]) {
            for (NSUInteger k = 0; k < currentSection.items.count; ++k) {
                id currentItem = currentSection.items[k];
                if (EQUAL(currentItem, item)) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)k inSection:(NSInteger)i];
                    [result addObject:indexPath];
                }
            }
        }
    }
    return result;
}


- (NSArray <RCTableSection *> *)sectionsContainingItem:(id)item {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSUInteger i = 0; i < self.sections.count; ++i) {
        RCTableSection *section = self.sections[i];
        if ([section.items containsObject:item]) {
            [result addObject:section];
            break;
        }
    }
    return result;
}

- (void)reloadItemAtIndexPath:(NSIndexPath *)indexPath animation:(UITableViewRowAnimation)animation {
    if (indexPath) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (CGFloat)heightForItem:(id)item {
    return 44.;
}

- (CGFloat)heightForHeaderViewOfSection:(RCTableSection *)section {
    return 0.00001f;
}

- (CGFloat)heightForFooterViewOfSection:(RCTableSection *)section {
    return 0.00001f;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"no cell identifier" reason:@"identifier should be provided by childs of RCTableManager" userInfo:nil];
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (NSArray *)cellNibNames {
    return nil;
}

- (NSString *)headerIdentifierForSection:(RCTableSection *)section {
    return nil;
}

- (NSString *)footerIdentifierForSection:(RCTableSection *)section {
    return nil;
}

- (void)configureHeaderView:(UIView *)view forSection:(RCTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (void)configureFooterView:(UIView *)view forSection:(RCTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
