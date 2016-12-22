//
//  TextCell.h
//

#import <UIKit/UIKit.h>

#import "RCBaseDevelopmentCell.h"

@class RCDevelopmentCell;

@interface RCDevelopmentCell : RCBaseDevelopmentCell

@property (weak, nonatomic) IBOutlet UILabel *imageMissedLabel;
@property (strong, nonatomic) DidPressedProjectImageBlock didPressedProjectImageBlock;

@end
