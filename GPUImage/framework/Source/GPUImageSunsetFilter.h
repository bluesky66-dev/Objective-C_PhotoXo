#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageSunsetFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
