#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageHighContrastFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
