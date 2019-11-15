#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageClassicFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
