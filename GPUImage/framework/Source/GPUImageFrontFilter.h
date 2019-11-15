#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageFrontFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
