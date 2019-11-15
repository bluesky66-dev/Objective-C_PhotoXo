#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageNeatFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
