#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImagePitchedFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
