#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageMellowFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
