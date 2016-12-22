//
//  TextCell.m
//

#import "RCDevelopmentCell.h"

#import "RCImage.h"
#import "RCProject.h"
#import "RCInteractiveImageView.h"

@interface RCDevelopmentCell ()

@property (strong, nonatomic) id <SDWebImageOperation> lastImageDownloadingOperation;

@end

@implementation RCDevelopmentCell

- (void)setItem:(id)item
{
    [super setItem:item];
    
    if ([item isKindOfClass:[RCProject class]]) {
        RCProject *project = (RCProject *)self.item;
        self.leftImageView.image = nil;
        [self.lastImageDownloadingOperation cancel];
        self.lastImageDownloadingOperation = [self.leftImageView setImageWithURLstring:[project.previewImage.url urlStringWithImageSize:RCImageThumbnail]
                                                                      placeholderImage:IMG(@"project_preview_mini_placeholder")
                                                                       imageMissedView:self.imageMissedLabel
                                                                            completion:nil];
        @weakify(self);
        self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
            @strongify(self);
            RUN_BLOCK(self.didPressedProjectImageBlock, project);
        };
    }
}

- (IBAction)commentAction {}

@end
