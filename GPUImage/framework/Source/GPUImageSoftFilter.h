#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageSoftFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
