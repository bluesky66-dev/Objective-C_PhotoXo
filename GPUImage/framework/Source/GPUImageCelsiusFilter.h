#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageCelsiusFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
