#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageFallFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
