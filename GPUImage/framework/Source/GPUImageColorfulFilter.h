#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageColorfulFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
