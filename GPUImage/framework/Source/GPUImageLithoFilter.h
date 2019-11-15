#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageLithoFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
