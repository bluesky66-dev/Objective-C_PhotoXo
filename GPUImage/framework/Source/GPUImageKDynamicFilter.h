#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageKDynamicFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
