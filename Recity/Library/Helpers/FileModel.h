//
//  FileModel.h
//  Wacatch
//
//  Created by Pavel Deminov on 18/03/16.
//  Copyright © 2016 Siberian.pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *type;

@end
