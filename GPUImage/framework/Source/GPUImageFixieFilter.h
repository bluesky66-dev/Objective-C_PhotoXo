#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

@interface GPUImageFixieFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
