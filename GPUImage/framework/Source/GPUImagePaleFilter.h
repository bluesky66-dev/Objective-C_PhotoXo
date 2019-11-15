#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImagePaleFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
