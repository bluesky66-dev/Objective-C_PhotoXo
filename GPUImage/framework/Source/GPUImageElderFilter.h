#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageElderFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
