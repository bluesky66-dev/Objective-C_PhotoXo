#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageKeenFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
