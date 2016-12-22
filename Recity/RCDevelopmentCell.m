//
//  TextCell.m
//

#import "RCDevelopmentCell.h"
#import "Utils.h"
#import "RCProject.h"
#import "RCImage.h"
#import "UIImageView+SDWebImageMore.h"
#import "RCImage.h"

@interface RCDevelopmentCell ()

@property (strong, nonatomic) id <SDWebImageOperation> lastImageDownloadingOperation;

@end

@implementation RCDevelopmentCell

- (void)setProject:(RCProject *)project {
    [super setProject:project];
    
    self.leftImageView.image = nil;
    
    [self.lastImageDownloadingOperation cancel];
    self.lastImageDownloadingOperation = [self.leftImageView setImageWithURLstring:project.previewImage.url placeholderImage:IMG(@"project_preview_mini_placeholder") imageMissedView:self.imageMissedLabel];
    @weakify(self);
    self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock, self.project);
    };
}


- (IBAction)commentAction {
    
}

@end
