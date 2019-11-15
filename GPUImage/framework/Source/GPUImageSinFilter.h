#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageSinFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
