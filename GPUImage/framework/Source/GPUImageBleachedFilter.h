#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageBleachedFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
