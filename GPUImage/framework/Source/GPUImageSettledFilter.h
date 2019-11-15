#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageSettledFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
