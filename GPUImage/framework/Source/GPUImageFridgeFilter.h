#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageFridgeFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
