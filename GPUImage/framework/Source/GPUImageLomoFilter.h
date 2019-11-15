#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageLomoFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
