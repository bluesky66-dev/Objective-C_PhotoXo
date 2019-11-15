#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImagePlateFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
