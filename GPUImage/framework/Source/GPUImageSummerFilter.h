#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageSummerFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
