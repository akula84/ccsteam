//
//  Created by Denis Matveev on 18/02/16.
//

#import "BaseComfortTextInput.h"

/**!     @class Class for comfortable input data into textfields which located at scrollview which located on view (or any subview) of some viewcontroller
         @warn Not forget to init KeyboardInfo. See KeyboardInfo for it
 */
@interface ScrollViewComfortTextInput : BaseComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView withScrollViewInsideOwnerViewWhereTextFieldsLocated:(UIScrollView *)scrollView;

@end
