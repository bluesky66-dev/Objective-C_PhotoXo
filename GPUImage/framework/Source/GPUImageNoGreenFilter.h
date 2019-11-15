#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageNoGreenFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
