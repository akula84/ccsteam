//
//  RCKeyBoardManager.h
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@interface RCKeyBoardManager : NSObject

@property (assign, nonatomic) CGRect currentKeyBoardRect;
@property (assign, nonatomic, readonly) BOOL showKeyboard;

@end
