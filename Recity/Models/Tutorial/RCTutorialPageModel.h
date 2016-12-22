//
//  RCTutorialPageModel.h
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface RCTutorialPageModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) BOOL needShowImage;
@property (nonatomic) BOOL moveUp;

@property (strong, nonatomic) NSArray <NSValue *> *viewHoleFrames;

@property (nonatomic, copy) void (^selectionAction)(void);

@end
