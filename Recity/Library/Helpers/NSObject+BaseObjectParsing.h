//
//  NSObject+BaseObjectParsing.h
//  Dishero
//
//  Created by Alexander Kozin on 18.07.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BaseObjectParsing)

- (id)aw_parseTo:(Class)class;
- (NSString *)aw_modelClassNameForKey:(NSString *)key;

- (id)aw_valueForAPI:(SEL)selector;

@end
